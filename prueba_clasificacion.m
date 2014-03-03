%% Prueba clasificación

% include jar libraries to matlab environment
clear all; clc
%Add the path to weka
javaaddpath('/usr/share/java/weka.jar')
% javaaddpath('/usr/share/java/libsvm3.jar')


%% Siguiendo el manual de weka
% weka.core.converters.ArffLoader('./GPScaracteristicas_TamBloque10.arff')
% archi = java.lang.String('./GPScaracteristicas_TamBloque10.arff');
% weka.core.Instances('./GPScaracteristicas_TamBloque10.arff')

%%

import weka.core.converters.ArffLoader
import java.io.File;
import weka.classifiers.functions.MultilayerPerceptron

% Cargo los datos
filename = java.lang.String('GPScaracteristicas_TamBloque10.arff');
loader = ArffLoader(); % constructor del loader
loader.setFile(File(filename)); % cargo el archivo al loader
wekaOBJ = loader.getDataSet(); % recupero un objeto Instances del loader
wekaOBJ.setClassIndex(wekaOBJ.numAttributes -1); % la ultima columna es la clase


% Intentando clasificar
wekaClassifier = weka.classifiers.functions.MultilayerPerceptron();
o(1) = java.lang.String('-L'); % Learning rate
o(2) = java.lang.String('0.3'); % Learning rate
o(3) = java.lang.String('-M'); % Momentum
o(4) = java.lang.String('0.2'); % Momentum
o(5) = java.lang.String('-N'); % number of epochs
o(6) = java.lang.String('10000'); % number of epochs
o(7) = java.lang.String('-V'); % Percentage size of validation set to 
                                   % use to terminate training
o(8) = java.lang.String('0');                                   
o(9) = java.lang.String('-S');   % seed for random generator
o(10) = java.lang.String('0');   % seed for random generator
o(11) = java.lang.String('-E');  % The consequetive number of errors 
                                   % allowed for validation testing before 
                                   % the netwrok terminates
o(12) = java.lang.String('20');                                   
o(13) = java.lang.String('-H');   % comma seperated numbers for nodes on 
                                   % each layer
o(14) = java.lang.String('a');                                   
% o(15) = java.lang.String('-G');     % GUI will be opened
% o(16) = java.lang.String('-R');     % Reset the network won't be allowed

options = cat(1,o(1:end))
% wekaClassifier.setAutoBuild(true)
wekaClassifier.setOptions(options)
wekaClassifier.buildClassifier(wekaOBJ)



wekaClassifier.getOptions();

%% clasificando
% wekaClassifier.classifyInstance(wekaOBJ.firstInstance())
% wekaClassifier.classifyInstance(wekaOBJ.lastInstance())

for i=0:wekaOBJ.numInstances()-1
    salida(i+1) = wekaClassifier.classifyInstance(wekaOBJ.instance(i));
end

stem(salida)
%%
wekaOBJ.attributeStats(0)
%%




% import weka.classifiers.Evaluation.*
%%
% import weka.core.converters.ArffLoader;
% import java.io.File;
%     
% loader = ArffLoader();
% loader.setFile(File(filename));
% wekaOBJ = loader.getDataSet();
% wekaOBJ.setClassIndex(wekaOBJ.numAttributes -1);
% 
% %%
% % //Arff files
% ARFFtrainfile = &quot;/path/to/arfftrainfile.arff&quot;;
% ARFFtestfile = &quot;/path/to/arfftestfile.arff&quot;;
% % //Settings for the classifier
% v(1) = java.lang.String('-t');
% v(2) = java.lang.String(ARFFtrainfile);
% v(3) = java.lang.String('-T');
% v(4) = java.lang.String(ARFFtestfile);
% v(5) = java.lang.String('-S 0 -K 2 -D 3 -G 0.0010 -R 0.0 -N 0.5 -M 40.0 -C 10.0 -E 0.0010 -P 0.1');
% % //concatenate the settings in a string
% prm = cat(1,v(1:end));
% % //create classifier instance, and perform the evaluation
% classifier = javaObject('weka.classifiers.functions.LibSVM');
% weka.classifiers.Evaluation.evaluateModel(classifier,prm)
% % //open trainset&lt;span style=&quot;background-color: #ffffff;&quot;&gt; &lt;/span&gt;
% reader = javaObject('java.io.FileReader', ARFFTrainfile);
% dataset = javaObject('weka.core.Instances', reader);
% dataset.setClassIndex(dataset.numAttributes() - 1);
% % //build classifier model
% classifier.buildClassifier(dataset);
% ...
% while (true) {
% instance = javaObject('weka.core.Instance', length(attributes_Dataset));
% predicted = classifier.classifyInstance(instance);
% % //predict the class from the instance
% class = dataset.attribute(dataset.numAttributes() -1).value(predicted))
% % }
% % ...