#!/bin/bash
drupalcomposermodules="kaido24/web3_start"
startpath="$(pwd -P)"

# Get the correct download method
if [ ! -z $(command -v wget) ];
	then downloadcommand="wget -O";
elif [ ! -z $(command -v curl) ];
	then downloadcommand="curl -o"
else
	echo "No download method found";
	exit;
fi;

# Download composer
$downloadcommand composer.phar https://getcomposer.org/download/1.7.3/composer.phar
chmod 755 composer.phar

composer="php -d memory_limit=-1 $startpath/composer.phar"

# Get the project name
projectname="$1"

if [ -z "$projectname" ];
	then echo "Please supply a project name";
	exit;
fi;

if ! $composer -V;
	then echo "Please change the script to use the correct composer";
fi;

# Create a new project
echo Creating a new project "$projectname"

$composer create-project drupal-composer/drupal-project:8.x-dev "$projectname" --no-interaction --stability dev

# Install modules
cd "$startpath/$projectname"
	composer config repositories.web3_start_profile vcs https://github.com/kaido24/web3_start_profile
	$composer require drupal/devel:~1.0
	mkdir -p web/modules/custom;
	
	for i in $drupalcomposermodules;
		do $composer require "$i";
	done;
	
	mkdir -p web/themes/custom
	cd "$startpath/$projectname/web/themes/custom"
	#	$downloadcommand bootstrap_subtheme_gen.sh https://raw.githubusercontent.com/kaido24/drupal8_bootstrap_subtheme_gen/master/bootstrap_subtheme_gen.sh;
	#	printf "y\n""$projectname""_theme\n" | sh bootstrap_subtheme_gen.sh

rm "$startpath/composer.phar"
