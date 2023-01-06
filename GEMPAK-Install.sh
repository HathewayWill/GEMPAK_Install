#!/bin/bash



################# Creating folders for GEMPAK ##################################

export HOME=`cd;pwd`
mkdir $HOME/GEMPAK
mkdir $HOME/GEMPAK/Downloads


####################### Basic Package Management for GEMPAK #####################

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install make autoconf automake libtool gcc build-essential gfortran libx11-dev libxt-dev libxext-dev libmotif-dev libxft-dev libxtst-dev xorg xbitmaps flex byacc locate libmotif-common libmotif-dev xfonts-100dpi xfonts-75dpi xfonts-cyrillic libxpm4 libxpm-dev gfortran-8

################### Download GEMPAK tarball and untar into GEMPAK folder #####################
cd $HOME/GEMPAK/Downloads
wget https://github.com/Unidata/gempak/archive/refs/tags/7.14.0.1.tar.gz
tar -xvzf 7.14.0.1.tar.gz -C $HOME/GEMPAK

################### Creating symbolic link to GEMPAK7 to NAWIPS ##############################

cd $HOME/GEMPAK
ln -s gempak-7.14.0.1/ NAWIPS

###################### Edit Gemenviron & Gemenviron.profile #################################
#Using uncommon delimiters for sed
#Changing default path for GEMPAK to current location


cd $HOME/GEMPAK/gempak-7.14.0.1
sed -i "s|setenv NAWIPS /home/gempak/GEMPAK7|setenv NAWIPS $HOME/GEMPAK/gempak-7.14.0.1|" Gemenviron
sed -i "s|NAWIPS=/home/gempak/GEMPAK7|NAWIPS=$HOME/GEMPAK/gempak-7.14.0.1|" Gemenviron.profile


####################### Sourcing Environmental Variables ###########################
# Adding path of GEMPAK to /.bashrc $ /.profile
#This will be done with the cat command
#In terminal enter cat --help to understand options


cd $HOME

cat >> .bashrc <<'EOF'
. /$HOME/GEMPAK/NAWIPS/Gemenviron.profile
EOF
source .bashrc                                #sourcing .bashrc to enable path.

cat >> .profile <<'EOF'
. /$HOME/GEMPAK/NAWIPS/Gemenviron.profile
EOF
source .profile                              #sourcing .profile to enable path.


################################## Installing GEMPAK 7.10.0.1 #################################
# Linking Make files to proper locations
# Adjusting FC variable from default gfortran to gfortran-8


cd $HOME/GEMPAK/NAWIPS/config
mv Makeinc.linux64_gfortran Makeinc.linux64_gfortran.orig
ln -s Makeinc.linux64_gfortran_ubuntu Makeinc.linux64_gfortran

sed -i 's/FC = gfortran/FC = gfortran-8/p' Makeinc.linux64_gfortran_ubuntu


cd $HOME/GEMPAK/NAWIPS
echo 'Make all in progress.'
echo 'To see code, in new terminal enter (tail -f make.out) in $HOME/GEMPAK/NAWIPS'
make all >& make.out    # Invoking Make to compile GEMPAK7.14.0.1 w/ tail output.


echo 'Make programs_nc in progress'
echo 'To see code, in new terminal enter (tail -f make.out.nc) in $HOME/GEMPAK/NAWIPS'
make programs_nc >& make.out.nc 


echo 'Make programs_gf in progress'
echo 'To see code, in new terminal enter (tail -f make.out.gf) in $HOME/GEMPAK/NAWIPS'
make programs_gf >& make.out.gf


echo 'Make install in progress'
echo 'To see code, in new terminal enter (tail -f make.out.install) in $HOME/GEMPAK/NAWIPS'
make install >& make.out.install

echo 'GEMPAK INSTALLED'

echo 'Thank you for using my GEMPAK install script'
echo 'Special thanks to github users akrherz & mzuranski'

















