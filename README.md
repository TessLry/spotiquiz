# Spotiquiz

Spotiquiz est une application de blind test qui fonctionne via une connexion à Spotify. 


# Informations 
<b>Version de flutter</b> : 3.16.4 <br>
<b>Version de dart</b> : 3.2.3 <br>
<b>API utilisé</b> : spotify api

# Fonctionnalités de l'application

### Page de connection
Possibilité de se connecter via un compte spotify premium

### Page d'accueil
Choix du mode de blind test : par artiste ou par album
<br>
Choix du nombre de musiques pour le blind test
<br>
Recherche de artists/album avec 3 propositions basés sur la recherche et l'API spotify

### Page score
Affichage du classement des meilleurs score, stocké dans les shared preferencies

### Page jeu
Autocompletion des réponses basés sur tous les sons restant dans la partie
Possibilité d'ajouter à nos titres likés spotify la musique à deviner

# Limites de l'application

### Support
L'application ne fonctionne pour l'instant que sous android

### Bug sur la connection
Sur certains modèles, la connection peut charger indéfiniment. Une solution est de lancer Spotify sur le téléphone, et de le laisser en tâche de fond. Spotiquiz peut ainsi se connecter.

### Limites d'artistes
Certains artistes ont désactivé la possibilité de lire leurs musiques en dehors de spotify, et ne proposent donc pas de prévisualisation via internet. Nous avons donc désactiver tout les artistes ne proposant pas cette fonctionnalité, 


# Prérequis pour lancer l'application
L'application est encore en développement, et nous utilisons l'API de spotify en mode développement, et non production. De ce fait nous devons enregistrer en amont les utilisateurs amenés à se connecter. Voici ce dont nous avons besoin :

#### SHA-1 key
A partir d'un terminal, entrer dans le dossier "android", puis écrire : <br>
<code>./gradlew signingReport</code>
Il faudra ensuite copier le SHA-1 et l'envoyer aux développeurs

#### Mail utilisateur
Nous devons également renseigner à spotify l'adresse mail de l'utilisateur qui sera amener à se connecter, elle est donc à fournir avec le SHA-1

#### Ajout des credentials
Afin de ne pas partager nos credentials en ligne, il faudra ajouter le fichier "credentials.dart" que nous vous fourniront dans le dossier "utils"
