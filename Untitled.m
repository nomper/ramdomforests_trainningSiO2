clear 

load carsmall
Tbl = table(Cylinders,Displacement,Horsepower,Weight,MPG);
Mdl1 = fitrensemble(Tbl,'MPG');
pMPG = predict(Mdl1,[4 200 150 3000])
formula = 'MPG ~ Cylinders + Horsepower + Weight';
Mdl2 = fitrensemble(Tbl,formula);
mse1 = resubLoss(Mdl1)
mse2 = resubLoss(Mdl2)
