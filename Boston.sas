/**************************** BOSTON Housing : Analyse ************************************/

/* Définir le chemin vers le dossier data */
%let path = /home/u59501961/sasuser.v94/Boston Housing study/Data;

/***************** Importer le fichier CSV *****************/
proc import datafile="&path./BostonHousing.csv"
    out=boston_data
    dbms=csv
    replace;
    getnames=yes;
run;

/* Afficher les premières lignes du dataset pour vérifier l'importation */
proc print data=boston_data (obs=10);
run;



/* 
Le jeu de données sur le logement de Boston est une ressource classique et largement utilisée 
dans le domaine de l'apprentissage automatique et des statistiques. Ce jeu de données offre 
un aperçu complet du paysage immobilier de Boston, Massachusetts, en se concentrant sur 
les principaux attributs influençant les prix des logements. Compilé à partir des données du 
recensement, ce jeu de données propose une gamme de variables incluant des facteurs tels que 
les taux de criminalité, les taux d'imposition foncière, les niveaux d'éducation, l'accessibilité 
aux autoroutes, et bien plus encore. Les chercheurs, analystes et passionnés de données peuvent 
explorer ce jeu de données pour identifier des modèles, construire des modèles prédictifs et 
obtenir des informations précieuses sur l'interaction complexe des facteurs qui affectent les 
marchés immobiliers urbains.

Vous trouverez plus de détail sur les différentes variables dans le fichier Variables.txt
*/

/***************** Statistiques descriptives & Correlation *****************/
proc corr data=boston_data outp=corr_matrix;
    var crim zn indus chas nox rm age dis rad tax ptratio b lstat medv;
run;


/*
Les résultats de la statistique descriptive pour le jeu de données Boston Housing indiquent une diversité significative dans les variables étudiées.
Par exemple, le taux de criminalité moyen est relativement bas avec une moyenne de 3.61, mais présente une dispersion considérable allant de 0.01 à 88.98.
De même, la proportion moyenne de terrains résidentiels zonés pour les grands lots est de 11.36%, avec une variation importante de 0% à 100%.
Ces écarts mettent en évidence la complexité des données urbaines étudiées, reflétant la diversité des contextes socio-économiques et environnementaux à Boston.

En ce qui concerne les caractéristiques physiques et environnementales, la concentration moyenne d'oxyde d'azote est de 0.55, avec des valeurs s'étendant de 0.39 à 0.87.
De plus, le nombre moyen de pièces par logement est d'environ 6.28, variant de 3.56 à 8.78. Ces résultats montrent une variabilité substantielle dans les attributs du logement à Boston,
ce qui est essentiel pour comprendre les dynamiques du marché immobilier urbain et pour éventuellement développer des modèles prédictifs robustes.
*/

/* focus sur crm */
proc print data=corr_matrix;
    var _NAME_ _TYPE_ crim;
run;


/*
La variable `crim` (taux de criminalité) présente des corrélations positives avec `indus`, `nox`, `rad`, et `tax`,
suggérant une possible influence des zones industrielles, de la pollution atmosphérique, de l'accessibilité aux autoroutes,
et du taux d'impôt foncier sur le niveau de criminalité. À l'inverse, `crim` montre des corrélations négatives avec `zn`, `chas`, `rm`, `dis`, et `b`,
indiquant que les quartiers résidentiels, ceux près de la rivière Charles, avec des logements spacieux, une bonne accessibilité aux emplois,
et une population diversifiée pourraient avoir moins de criminalité.
*/

/***************** Analyse de la distribution */

proc univariate data=boston_data;
    var crim indus nox age dis rad tax b lstat medv;
    histogram / normal;
    ods select Histogram;
run;

/* Analyse Boxplot*/
proc sgplot data=boston_data;
    vbox crim ;
    /* Titre du graphique */
    title 'Boxplot pour la variable crim';
run;


/***************** Analyse Bivariée *****************/

/* Graphique de dispersion pour crim et indus */
proc sgplot data=boston_data;
    scatter x=crim y=indus / markerattrs=(symbol=circlefilled) transparency=0.6;
    
    /* Titre du graphique */
    title 'Évolution de crim et indus';

    /* Légende pour les axes */
    xaxis label='crim';
    yaxis label='indus';
run;


proc sgplot data=boston_data;
    scatter x=crim y=rad / markerattrs=(symbol=circlefilled) transparency=0.6;
    
    /* Titre du graphique */
    title 'Évolution de crim et rad';

    /* Légende pour les axes */
    xaxis label='crim';
    yaxis label='rad';
run;

