echo "The command specifies that the input comes from the resource named donut.csv, that the resulting model is stored in the file ./model, that the target variable is in the field named color and that it has two possible values. The command also specifies that the algorithm should use variables x and y as predictors, both with numerical types. The remaining options specify internal parameters for the learning algorithm."
mahout trainlogistic --input ../data/mahout/donut.csv \
--output ../data/mahout/model \
--target color --categories 2 \
--predictors x y --types numeric \
--features 20 --passes 100 --rate 50

echo "Calculate AUC.  The output here contains two values of particular interest. First, the AUC value (an acronym for area under the curve—a widely used measure of model quality) has a value of 0.57. AUC can range from 0 for a perfectly perverse model that’s always exactly wrong to 0.5 for a model that’s no better than random to 1.0 for a model that’s perfect. The value here of 0.57 indicates a model that’s hardly better than random."
mahout runlogistic --input ../data/mahout/donut.csv \
--model ../data/mahout/model --auc --confusion

echo "You can get more interesting results if you use additional variables for training. For instance, this command allows the model to use x and y as well as a, b, and c to build the model"
mahout trainlogistic --input ../data/mahout/donut.csv --output ../data/mahout/model \
--target color --categories 2 \
--predictors x y a b c --types numeric \
--features 20 --passes 100 --rate 50

echo "And a perfect AUC score"
mahout runlogistic --input ../data/mahout/donut.csv \
--model ../data/mahout/model --auc --confusion
