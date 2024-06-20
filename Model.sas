/**************************** BOSTON Housing : Mdoélisation ************************************/

/* Définir le chemin vers le dossier data */
%let path = /home/u59501961/sasuser.v94/Boston Housing study/Data;

/***************** Importer le fichier CSV *****************/
proc import datafile="&path./BostonHousing.csv"
    out=boston_data
    dbms=csv
    replace;
    getnames=yes;
run;


/*
Nous allons maintenant nous concentrer sur la création de notre modèle visant à expliquer le taux de criminalité (variable y).
Pour ce faire, nous utiliserons les différentes variables disponibles dans notre base de données de Boston.

Dans ce premier modèle, nous nous focaliserons particulièrement sur la variable `rad`, étant donné sa corrélation la plus élevée avec le taux de criminalité.
*/

/***************** Modèle OLS avec une seule variable explicative (rad) *****************/
proc reg data=boston_data;
    model crim = rad;
run;


/*
L'analyse de variance montre que le modèle dans son ensemble est significatif (F(1, 504) = 323.94, p < 0.0001),
indiquant que la variable explicative (rad) est significativement associée à la variable dépendante.
Le modèle explique environ 39.1% de la variation dans la variable dépendante (R² = 0.3913, R² ajusté = 0.3900).
Le coefficient pour la variable `rad` est estimé à 0.61791 (erreur standard = 0.03433, t = 18.00, p < 0.0001),
suggérant une relation positive significative avec la variable dépendante.

Nous allons maintenant incluire les 3 variables les plus correlés avec notre variable crime.
*/

proc reg data=boston_data;
    model crim = tax nox rad ;
run;
/* 
- Le modèle dans son ensemble est significatif (F(3, 502) = 108.75, p < 0.0001)
- Le modèle explique environ 39.4% de la variation dans le taux de criminalité (R² = 0.3939, R² ajusté = 0.3903).
- Pour chaque unité d'augmentation de la variable rad, le taux de criminalité augmente en moyenne de 0.54654 unités (p < 0.0001), ce qui suggère une relation positive significative.
- Les variables tax et nox n'ont pas d'effet statistiquement significatif sur le taux de criminalité (p = 0.6283 pour tax et p = 0.2497 pour nox).

Interprétation économique :

-> Ces résultats indiquent que la proximité aux autoroutes (rad) est un facteur significatif influençant le taux de criminalité à Boston.
Cela suggère que des niveaux accrus d'accessibilité aux autoroutes radiales sont associés à une augmentation du taux de criminalité,
probablement en raison de facilités accrues pour les déplacements criminels.

-> Tandis que les niveaux de taxation (tax) et les concentrations d'oxydes d'azote (nox) n'ont pas d'impact significatif dans ce modèle.
n revanche, la variable `tax` (Taux d'impôt foncier) montre une non-significativité (p = 0.6283), avec un coefficient proche de zéro (\(\beta = 0.00221\)).
Cela indique que le taux d'impôt foncier n'a pas d'influence mesurable sur le taux de criminalité dans cette analyse,
soulignant que d'autres facteurs socio-économiques sont plus prédominants.
*/


/***************** Modèle OLS avec toutes les variables et test de multicolinéarité *****************/

proc reg data=boston_data;
    model crim = indus nox age dis rad tax b lstat medv / vif ;
run;



/*
Interprétation:

- **Intercept (constante)** :
  - Coefficient : 10.44584
  - Interprétation : La valeur moyenne du taux de criminalité lorsque toutes les variables explicatives sont égales à zéro.

- **indus (Proportion d'acres commerciaux non résidentiels par ville)** :
  - Coefficient : -0.12973, p = 0.1118
  - Non significatif (p > 0.05)
  - Interprétation : La proportion d'acres commerciaux non résidentiels n'a pas d'effet significatif sur le taux de criminalité dans cette analyse.

- **nox (Concentration en oxydes nitriques)** :
  - Coefficient : -6.45990, p = 0.1887
  - Non significatif (p > 0.05)
  - Interprétation : La concentration en oxydes nitriques n'a pas d'effet significatif sur le taux de criminalité dans cette analyse.

- **age (Proportion de logements occupés par leurs propriétaires construits avant 1940)** :
  - Coefficient : -0.00510, p = 0.7713
  - Non significatif (p > 0.05)
  - Interprétation : L'âge des logements n'a pas d'effet significatif sur le taux de criminalité.

- **dis (Distance moyenne vers cinq centres d'emploi de Boston)** :
  - Coefficient : -0.63201, p = 0.0138
  - Significatif (p < 0.05)
  - Interprétation : Une plus grande distance par rapport aux centres d'emploi est associée à une réduction du taux de criminalité, 
  suggérant que des zones plus éloignées des centres d'emploi peuvent avoir moins de criminalité.

- **rad (Indice d'accessibilité aux autoroutes radiales)** :
  - Coefficient : 0.51745, p < 0.0001
  - Significatif (p < 0.05)
  - Interprétation : Une accessibilité accrue aux autoroutes radiales est fortement associée à une augmentation du taux de criminalité,
  probablement en facilitant les déplacements des criminels.

- **tax (Taux d'impôt foncier)** :
  - Coefficient : -0.00011015, p = 0.9825
  - Non significatif (p > 0.05)
  - Interprétation : Le taux d'impôt foncier n'a pas d'effet significatif sur le taux de criminalité dans cette analyse.

- **b (Proportion de Noirs par ville)** :
  - Coefficient : -0.00917, p = 0.0119
  - Significatif (p < 0.05)
  - Interprétation : Une proportion plus élevée de la population noire est associée à une légère réduction du taux de criminalité.

- **lstat (Pourcentage de statut inférieur de la population)** :
  - Coefficient : 0.14794, p = 0.0409
  - Significatif (p < 0.05)
  - Interprétation : Un pourcentage plus élevé de la population à statut socio-économique inférieur est associé à une augmentation du taux de criminalité.

- **medv (Valeur médiane des maisons occupées par leurs propriétaires)** :
  - Coefficient : -0.11337, p = 0.0231
  - Significatif (p < 0.05)
  - Interprétation : Une valeur médiane plus élevée des maisons est associée à une réduction du taux de criminalité, suggérant que les zones plus prospères peuvent avoir moins de criminalité.
*/

/*
Présence de multicolinéarité entre des variabes nox et ind: corrélation entre ces deux variables de 0.7
De meme que nox et age corrélation de 0.7
tax et rad
*/

/* Interprétation des VIF pour chaque variable :
 * - indus : VIF = 3.74, faible multicolinéarité.
 * - nox : VIF = 3.88, faible multicolinéarité.
 * - age : VIF = 2.92, faible multicolinéarité.
 * - dis : VIF = 3.48, faible multicolinéarité.
 * - rad : VIF = 6.52, multicolinéarité modérée.
 * - tax : VIF = 8.57, multicolinéarité modérée à élevée.
 * - b : VIF = 1.32, faible multicolinéarité.
 * - lstat : VIF = 3.19, faible multicolinéarité.
 * - medv : VIF = 2.51, faible multicolinéarité.
 */

