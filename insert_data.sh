#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")

cat games.csv | while IFS=',' read Year Round Winner Opponent Winner_Goals Opponent_Goals
do
  if [[ $Winner != 'winner' ]]
  then 
  #get team_id
  TEAM_ID_WINNER=$($PSQL "select team_id from teams where name='$Winner'")
  TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name='$Opponent'")
  #if don't found
  if [[ -z $TEAM_ID_WINNER ]] #this will be true when team_id is null
  then
    #add team into the table
    INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$Winner')")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into teams:$Winner
    fi
  fi

  if [[ -z $TEAM_ID_OPPONENT ]]
  then
     #add team into the table
    INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$Opponent')")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into teams:$Opponent
    fi
  fi  
  fi
done

cat games.csv | while IFS=',' read Year Round Winner Opponent Winner_Goals Opponent_Goals
do
  if [[ $Year != 'year' ]]
  then
    TEAM_ID_WINNER=$($PSQL "select team_id from teams where name='$Winner'")
    TEAM_ID_OPPONENT=$($PSQL "select team_id from teams where name='$Opponent'")
    #insert year in game
    INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($Year,'$Round',$TEAM_ID_WINNER,$TEAM_ID_OPPONENT,$Winner_Goals,$Opponent_Goals)")
    echo $INSERT_GAME_RESULT
  fi
done

