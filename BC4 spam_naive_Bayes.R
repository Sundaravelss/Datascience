# Aller sur kaggle et chercher le dataset sms_spam.csv puis le telecharger 
#dans la working directory
sms_raw<-read.csv("BC4sms_spam_copie.csv",stringsAsFactors = TRUE)
# Examiner la structure du dataset
str(sms_raw)
# le type est un vecteur formé de caractéres il faut le convertir en factor 
sms_raw$type<-factor(sms_raw$type)
# on vérifie que la transformation a bien eu lieu
str(sms_raw)
# on regarde la proportion de spam vs ham dans les sms
table(sms_raw$type)
# je trouve 4827 ham et 747 spam
# preparation des données
# il faut enlever les virgules les mots inutiles pour cela on install le package tm
library(tm)
# il faut ensuite créer un corpus cad un ensemble de documents (ici des sms)
sms_corpus<-VCorpus(VectorSource(sms_raw$text))
# on verifie que le Corpus contient bien le même nombre de documents que de sms
print(sms_corpus)
# il y a bien 5574 documents
# pour inspecter les deux premiers documents du corpus
inspect(sms_corpus[1:2])
#pour lire les textes d'un document
as.character(sms_corpus[[1]])
# pour lire plusieurs messages il faut appliquer plusieurs fois la commande as.character
# ceci est obtenu en utilisant lapply qui applique une procédure sur plusieurs objets
lapply(sms_corpus[1:2],as.character)
# on va enlever les mots inutiles , les ponctuations et regrouper HELLO et Hello qui ont 
# le même sens , on crée un nouveau corpus nettoyé grace à la fonction tm_map
# 1ere etape : supprimer les majuscules
sms_corpus_clean<-tm_map(sms_corpus,content_transformer(tolower))
# on vérifie sur un sms que les majuscules ont bien été enlevées
as.character(sms_corpus[[1]])
as.character(sms_corpus_clean[[1]])
# on enléve les nombres des sms
sms_corpus_clean<-tm_map(sms_corpus_clean, removeNumbers)
# on enléve les mots de remplissage tels que to,and,but connus
# sous le nom de stop words
sms_corpus_clean<-tm_map(sms_corpus_clean,removeWords,stopwords())
# cette commande utilise une liste de stop word préetablie 
# mais on peut constituer sa propre liste et il existe des
# listes dans d'autres langages
# eliminer la ponctuation
sms_corpus_clean<-tm_map(sms_corpus_clean, removePunctuation)
# installer le SnowballC package
library(SnowballC)
# Ce package permet de faire du stemming cad reduire plusieurs 
# mot à leur racines identiques ex learning , learned, learn
wordStem(c("learn","learned","learning","learns"))
sms_corpus_clean<-tm_map(sms_corpus_clean, stemDocument)
# Enlever les espaces blancs 
sms_corpus_clean<-tm_map(sms_corpus_clean,stripWhitespace)
# Faire un test pour comparer les 3 premiers messages 
# du corpus avant et aprés nettoyage
as.character(sms_corpus[1:3])
as.character(sms_corpus_clean[1:3])
# il faut tokeniser les mots La fonction DocumentTermMatrix(DTM)
# va créer une matrice avec en colonne chaque mot et les lignes
# sont des sms  dans chaque cellule
# du tableau se trouve le nombre de fois ou le mot apparait dans le sms
# il y a donc une colonne par mot ce qui fait plus de 7000 colonnes
# pour l'ensemble des sms du corpus
sms_dtm<- DocumentTermMatrix(sms_corpus_clean)
# on aurait pu aboutir a peu pres au même resultat en partant 
# du corpus initial avec la commande suivante
sms_dtm2 <- DocumentTermMatrix(bers = TRUE,stopwords = TRUE,removePunctuation = TRUE, stemming = TRUE))
# préparation du Train et du Test 
sms_dtm_train<-sms_dtm[1:4169,]
sms_dtm_test<-sms_dtm[4170:5574,]
# on prépare les labels à part
sms_train_labels<-sms_raw[1:4169,]$type
sms_test_labels<-sms_raw[4170:5574,]$type
# on verifie la proportion de ham et spam dans le train labels elle doit etre identique à celle
# de tests pour montrer que test est bien representatif
prop.table(table(sms_train_labels))
prop.table(table(sms_test_labels))
# on va representer des nuages de mots il faut donc installer le package 
install.packages("wordcloud")
library(wordcloud)
install.packages("RColorBrewer")
library(RColorBrewer)
# on crée un nuage de mots avec la syntaxe 
wordcloud(sms_corpus_clean,min.freq = 50,random.order = FALSE)
#min.freq spécifie le nombre minimum de fois ou le mot apparait pour figurer dans le nuage
#random.order = ordre aléatoire ou non
# on crée ensuite deux subsets de la matrice initiale pour ham et spam puis on réalise
# les nuages de mots correspondants et on les compare
spam<-subset(sms_raw, type == "spam")
ham<-subset(sms_raw, type=="ham")
# on crée ensuite les deux nuages de points avec une limite du nombre 
# de mots
wordcloud(spam$text,max.words=40,scale=c(3,0.5))
wordcloud(ham$text,max.words=40,scale=c(3,0.5))
# on va maintenant préparer la structure de données pour
# faire la classification pour cela il faut selectionner
# les mots qui apparaissent le plus souvent dans au moins 5
#sms 
# on utilise la fonction findFreqTerms() du package tm
sms_freq_words<-findFreqTerms(sms_dtm_train,5)
# on selectionne les colonnes qui correspondent aux mots les 
# plus fréquents
sms_dtm_freq_train<-sms_dtm_train[,sms_freq_words]
sms_dtm_freq_test<-sms_dtm_test[,sms_freq_words]
# le classifier Naive Bayes est typiquement adapté aux 
# variables categorielles or dans le tableau il ya des chiffres
# il faut donc les transformer en categories
# on crée une fonction qui transforme les chiffres en oui ou non suivant qu'il est positif ou nul 
convert_counts<-function(x) {x<-ifelse(x>0,"Yes","No")}
# on applique cette fonction sur toutes les colonnes ou les lignes de la matrice
# si on veut sur les lignes on specifie MARGIN=1 , sur les colonnes =2
sms_train<-apply(sms_dtm_freq_train,MARGIN=2, convert_counts)
sms_test<-apply(sms_dtm_freq_test,MARGIN=2, convert_counts)
# on applique l'algorithme Naive Bayes on installe le package 
# e1071
install.packages("e1071")
library(e1071)
# syntaxe de la commande naivebayes m <- naibayes(train,class,laplace =0) laplace=laplace estimator
# p<-predict(m, test, type ="class") test doit etre un dataframe du meme type que train
sms_classifier<-naiveBayes(sms_train,sms_train_labels)
# par defaut laplace=0
sms_test_prediction<-predict(sms_classifier,sms_test)
# pour comparer la prediction on utilise Crosstable du package gmodels
library(gmodels)
CrossTable(sms_test_prediction,sms_test_labels,prop.chisq=FALSE,prop.t=FALSE,dnn=c("predicted","actual"))
# on constate que l'algorithme s'est trompé sur 2,6% des messages 
# seulement Naive Bayes est l'algorithme le plus simple et
# le plus performant pour les classifications de textes.

