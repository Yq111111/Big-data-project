import au.com.bytecode.opencsv.CSVReader;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.FlatMapFunction;
import org.apache.spark.ml.classification.MultilayerPerceptronClassificationModel;
import org.apache.spark.ml.classification.MultilayerPerceptronClassifier;
import org.apache.spark.ml.evaluation.MulticlassClassificationEvaluator;
import org.apache.spark.ml.feature.*;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.RowFactory;
import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.types.DataTypes;
import org.apache.spark.sql.types.Metadata;
import org.apache.spark.sql.types.StructField;
import org.apache.spark.sql.types.StructType;
import scala.Tuple2;

import java.io.StringReader;
import java.util.Iterator;

public class Word2VecPredict {
    public static class ParseLineWhole implements FlatMapFunction<Tuple2<String, String>, String[]> {
        public Iterator<String[]> call(Tuple2<String, String> file) throws Exception {
            CSVReader reader = new CSVReader(new StringReader(file._2()));
            Iterator<String[]> data = reader.readAll().iterator();
            reader.close();
            return data;
        }
    }
    public static void main(String[] args){
        SparkConf conf=new SparkConf().setAppName("word2vec").setMaster("local[*]");
        JavaSparkContext sc=new JavaSparkContext(conf);
        JavaPairRDD<String,String> csvData=sc.wholeTextFiles("/home/2018/spring/nyu/6513/qy508/P2/data/tt.csv");
        //JavaPairRDD<String,String> csvData=sc.wholeTextFiles("C:/Users/qy508/Desktop/tt.csv");
        JavaRDD<String[]> keyedRDD = csvData.flatMap(new ParseLineWhole());
        JavaRDD<Row> rowRDD=keyedRDD.map(s-> {
            if(Integer.valueOf(s[6].toString())>=3) {
                return RowFactory.create(s[0], s[5],"good");
            }else{
                return RowFactory.create(s[0], s[5],"bad");
            }
        }).repartition(10);
        System.out.print("This first step:"+rowRDD.first());
        StructType schema = new StructType(new StructField[]{
                new StructField("id", DataTypes.StringType,false, Metadata.empty()),
                new StructField("sentence", DataTypes.StringType, false, Metadata.empty()),
                new StructField("label", DataTypes.StringType, false, Metadata.empty())
        });
        SparkSession spark = SparkSession
                .builder()
                .appName("Java Spark SQL basic example")
                .master("local[*]")
                .config("spark.some.config.option", "some-value")
                .getOrCreate();
        Dataset<Row> sentenceData = spark.createDataFrame(rowRDD, schema);
        Tokenizer tokenizer = new Tokenizer().setInputCol("sentence").setOutputCol("words");
        Dataset<Row> wordsData = tokenizer.transform(sentenceData);
        //word2vec
        Word2Vec word2Vec = new Word2Vec()
                .setInputCol("words")
                .setOutputCol("result")
                .setWindowSize(8)
                .setVectorSize(100)
                .setNumPartitions(10)
                .setMinCount(100);
        Word2VecModel model1 = word2Vec.fit(wordsData);
        Dataset<Row> result = model1.transform(wordsData);
        //change label
        StringIndexer stringIndexer=new StringIndexer()
                .setInputCol("label")
                .setOutputCol("labelIndex");
        StringIndexerModel model2=stringIndexer.fit(result);
        result=model2.transform(result);
        System.out.println("This is second step"+result.first());
        //将数据集分开8/2
        Dataset<Row>[] splits = result.randomSplit(new double[]{0.8, 0.2});
        Dataset<Row> train = splits[0];
        Dataset<Row> test = splits[1];
        System.out.println("This is third step:"+train.first());
        //设置训练器
        int[] layers = new int[] {100, 5, 2};
        MultilayerPerceptronClassifier trainer = new MultilayerPerceptronClassifier()
                .setLayers(layers)
                .setBlockSize(128)
                .setSeed(1234L)
                .setMaxIter(100)
                .setFeaturesCol("result")
                .setLabelCol("labelIndex")
                .setPredictionCol("prediction");
        // train the model
        MultilayerPerceptronClassificationModel classify = trainer.fit(train);
        Dataset<Row> classresult = classify.transform(test);
        // compute accuracy on the test set
        Dataset<Row> predictionAndLabels = classresult.select("prediction","labelIndex");
        System.out.println(predictionAndLabels.first());
        MulticlassClassificationEvaluator evaluator = new MulticlassClassificationEvaluator()
                .setLabelCol("labelIndex")
                .setPredictionCol("prediction")
                .setMetricName("accuracy");
        classresult.select("words","prediction","labelIndex").show(30);
        System.out.println("Test set accuracy = " + evaluator.evaluate(predictionAndLabels));
    }
}
