#!/bin/bash #-vx

set -e

# Filename:  db/migrate/rake_create_migrations.sh
# Directory: /Users/abruzzim/Documents/ga_wdi/projects/blog
# Version:   0.0-2
# Author:    Mario Abruzzi
# Date:      16-Dec-2013
# Desc:      Create Rake Migration files for "bwain_db" HW
# Usage:     ./rake_create_migrations.sh [ user | post ]

# Define Bash Symbols

faci="RAKE_CREATE_MIGRATIONS"

# Check for a valid P1

if [ -z "${1}" ]; then
  seve="F"
  iden="NOP1"
  text="Null is not valid. Specify \"users\" or \"posts\". Exiting Bash Script."
  echo ""
  echo "%${faci}-${seve}-${iden}, ${text}"
  echo ""
  exit 1
fi

if [ "${1}" != "users" ] && [ "${1}" != "posts" ] ; then
  seve="F"
  iden="INVP1"
  text="Parameter \"${1}\" is not valid. Specify \"users\" or \"posts\". Exiting Bash Script."
  echo ""
  echo "%${faci}-${seve}-${iden}, ${text}"
  echo ""
  exit 1
fi

# Rake Migration Bash Menu

clear

orig_PS3=$PS3 # Save the existing value of PS3

PS3="Select Option (RETURN to list all options): "
select option in "Create PSQL database \"bwain_db\"" \
                 "Edit database.rb in Sublime" \
                 "Create Class models/user.rb" \
                 "Create Class models/post.rb" \
                 "Edit Rakefile in Sublime" \
                 "Create Rake Migration for \"users\" table" \
                 "Create Rake Migration for \"posts\" table" \
                 "Drop PSQL database \"bwain_db\"" \
                 "Run Rake Migrations" \
                 "Display Columns in \"bwain_db\"" \
                 "Help" \
                 "Quit"

do

  if [ "$REPLY" == "quit" ] || [ "$REPLY" == 12 ]; then
    # The 'break' must precede all other conditional checks.
    seve="I"
    iden="EXIT"
    text="Exiting Bash Script."
    echo ""
    echo "%${faci}-${seve}-${iden}, ${text}"
    echo ""
    break # Exit the loop.
  fi

  if [ "$REPLY" == "help" ]; then
    # User help section.
    echo "Create PSQL database \"bwain_db\"."
    echo "Edit database.rb file."
    echo "Create Class models/user."
    echo "Create Class models/post."
    echo "Edit Rakefile."
    echo "Create Rake Migration for \"users\" table."
    echo "Create Rake Migration for \"posts\" table."
    echo "Drop PSQL database \"bwain_db\"."
    echo "Run Rake Migrations and then display tables."
    echo "Display All Columns in \"bwain_db\""
    continue # Go back to the start of the loop.
  fi

  if [ ! -z "$option" ]; then # If the string is not zero length, then...

    echo "Option ${REPLY} was selected, which is ... "

    case $REPLY in
      1) echo "Creating PSQL database \"bwain_db\"..."
          psql --list
          psql --command="CREATE DATABASE bwain_db;"
          psql --list
          ;;
      2) echo "Edit database.rb..."
          subl ../../config/database.rb
          ;;
      3) echo "Create model/user.rb..."
          subl ../../models/user.rb
          ;;
      4) echo "Create model/post.rb..."
          subl ../../models/post.rb
          ;;
      5) echo "Edit Rakefile..."
          subl ../../Rakefile
          ;;
      6) echo "Creating Rake Migration for \"users\" table..."
          rake db:create_migration NAME=create_table_users
          #rake db:create_migration NAME=create_col_fname_to_users
          ;;
      7) echo "Creating Rake Migration for \"posts\" table..."
          rake db:create_migration NAME=create_table_posts
          #rake db:create_migration NAME=create_col_name_to_posts
          ;;
      8) echo "Dropping PSQL database \"bwain_db\"..."
          psql --list
          psql --command="DROP DATABASE bwain_db;"
          psql --list
          ;;
      9) echo "Run Rake Migrations for \"bwain_db\"..."
          rake db:migrate
          psql --command="\d" bwain_db
          ;;
     10) echo "Display columns for \"bwain_db\"..."
          psql --command="SELECT * FROM users;" bwain_db
          psql --command="SELECT * FROM posts;" bwain_db
          ;;
    esac

  else

    seve="E"
    iden="INVOPT"
    text="${REPLY} is not a valid menu option."
    echo ""
    echo "%${faci}-${seve}-${iden}, ${text}"
    echo ""

  fi

done

PS3=$orig_PS3 # Restore the original value of PS3

exit 0
