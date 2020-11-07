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


# Get the project name
projectname="$1"

if [ -z "$projectname" ];
	then echo "Please supply a project name";
	exit;
fi;


# Create a new project
echo Creating a new project "$projectname"

$composer create-project drupal-composer/drupal-project:8.x-dev "$projectname" --no-interaction --stability dev

# Install modules
cd "$startpath/$projectname"
	composer config repositories.web3_start_profile vcs https://github.com/kaido24/web3_start_profile
	$composer require drupal/devel
	mkdir -p web/modules/custom;
	
	for i in $drupalcomposermodules;
		do $composer require "$i";
	done;
	
	mkdir -p web/themes/custom
