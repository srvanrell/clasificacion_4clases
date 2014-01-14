%% Prueba clasificación

% include jar libraries to matlab environment
javaaddpath('/usr/share/java/weka.jar')
javaaddpath('/usr/share/java/libsvm3.jar')
%%
% imports java like
import weka.core.*
import weka.classifiers.*
import weka.classifiers.Classifier.*
import weka.classifiers.bayes.BayesNet.*
import weka.classifiers.Evaluation.*
%%
import weka.core.converters.ArffLoader;
import java.io.File;
    
loader = ArffLoader();
loader.setFile(File(filename));
wekaOBJ = loader.getDataSet();
wekaOBJ.setClassIndex(wekaOBJ.numAttributes -1);

%%
% //Arff files
ARFFtrainfile = &quot;/path/to/arfftrainfile.arff&quot;;
ARFFtestfile = &quot;/path/to/arfftestfile.arff&quot;;
% //Settings for the classifier
v(1) = java.lang.String('-t');
v(2) = java.lang.String(ARFFtrainfile);
v(3) = java.lang.String('-T');
v(4) = java.lang.String(ARFFtestfile);
v(5) = java.lang.String('-S 0 -K 2 -D 3 -G 0.0010 -R 0.0 -N 0.5 -M 40.0 -C 10.0 -E 0.0010 -P 0.1');
% //concatenate the settings in a string
prm = cat(1,v(1:end));
% //create classifier instance, and perform the evaluation
classifier = javaObject('weka.classifiers.functions.LibSVM');
weka.classifiers.Evaluation.evaluateModel(classifier,prm)
% //open trainset&lt;span style=&quot;background-color: #ffffff;&quot;&gt; &lt;/span&gt;
reader = javaObject('java.io.FileReader', ARFFTrainfile);
dataset = javaObject('weka.core.Instances', reader);
dataset.setClassIndex(dataset.numAttributes() - 1);
% //build classifier model
classifier.buildClassifier(dataset);
% ...
% while (true) {
% instance = javaObject('weka.core.Instance', length(attributes_Dataset));
% predicted = classifier.classifyInstance(instance);
% //predict the class from the instance
% class = dataset.attribute(dataset.numAttributes() -1).value(predicted))
% }
% ...