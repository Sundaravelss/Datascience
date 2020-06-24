#Aller sur Kaggle puis rechercher Wisconsin Breast Cancer dataset et faire download
# le dataset s'appelle data.csv le renommer en wisc_bc_data.csv
# Charger les librairies tidyverse et dplyr 
# Créer un nouveau dataset en mélangant les lignes
#load dataset
data<-read.csv("data.csv",stringsAsFactors = TRUE)
wbcd<-data%>%sample_n(569)
# Enlever la colonne id qui ne sert à rien pour la prédiction 
wbcd<-wbcd[-1]
# Regarder la proportion de diagnostics M et B 
table(wbcd$diagnosis)
#Transformer cette colonne diagnostic en facteur et donner un 
#label clair aux codes B et M
wbcd$diagnosis<-factor(wbcd$diagnosis,levels = c("B","M"),labels = c("Benin","Malin"))
#On examine les trois dernieres variables
summary(wbcd[c("radius_mean","area_mean","smoothness_mean")])
# on constate une grande disparité dans l'amplitude des 3 variables area_mean varie 
# entre 143 et 2501 pendant que smoothness_mean varie entre 0,05 et 0,16
# area_mean risque de fausser le resultat de la prediction il faut donc equilibrer
# l'amplitude de chaque variable pour cela on crée une fonction normalise 
normalize <- function(x) {return ((x - min(x)) / ((max(x) - min(x)))}
#la commande lapply applique la fonction normalize sur les colonnes 2 à 31 du dataset
# Cette commande agit sur une liste or un data frame est un ensemble de liste il faut 
# donc transformer le dataset en dataframe
wbcd_n <- as.data.frame(lapply(wbcd[,2:31], normalize))
# Création de deux dataset train et test 
wbcdtrain<-wbcd_n[1:469,]
wbcdtest<-wbcd_n[470:569,]
#Pour l'entrainement du modéle il faut stocker les labels Malin Benin de la premiere colonne
# du dataset initial
wbcd_train_labels<-wbcd[1:469,1]
wbcd_test_labels<-wbcd[470:569,1]
# on installe le package class
install.packages("class")
# on réalise la prediction avec la syntaxe p<-knn(train,test,cl,k)
# train et test sont les dataframe correspondants cl est le vecteur avec la classe de chaque 
# ligne du dataframe train k est le nombre de plus proches voisins à inclure dans le vote 
wbcd_pred<-knn(train = wbcdtrain, test = wbcdtest, cl=wbcd_train_labels$diagnosis, k=21)
# il m'a fallu une heure pour comprendre que wbcd_train_labels est un dataframe de une colonne
# or l'argument cl n'accepte qu'un vecteur il faut donc utiliser la syntaxe wbcd_train_labels$diagnosis

# il faut evaluer la perf du modéle a l'aide de la fonction CrossTable() du package(gmodels)
install.packages("gmodels")
CrossTable(x=wbcd_test_labels$diagnosis,y=wbcd_pred,prop.chisq=FALSE)
#la prédiction est 62 bénins prédits bénins mais 2 malins prédits bénins ce qui est trés grave !
