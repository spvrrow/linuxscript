#Opvragen variabelen
read -p "Gebruikersnaam: " NAAM
read -p "Email: " EMAIL
read -p "Github link: " GITLINK

git config --global user.name $NAAM
git config --global user.email $EMAIL
echo "####################################"
echo "Repository wordt aangemaakt in ~/git"
echo "####################################"
mkdir ~/git
echo "init"
git init ~/git
echo "origin"
cd ~/git
git remote add origin $GITLINK
