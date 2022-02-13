LENGTH=5

function convert_to_array() {
  local word=$1
  local index=0    

  while [[ ${index} -lt ${LENGTH} ]]
  do
    local player_word[$index]=${word:${index}:1}
    index=$(( ${index} + 1 ))
  done

  echo "${player_word[*]}"
}

function check_letter_presence() {
  local player_letter=$1
  local computer_word=( $2 )
  local result=$3

  local index=0  
  while [[ ${index} -lt ${LENGTH} ]]
  do
    if [[ ${player_letter} == ${computer_word[$index]} ]]
    then
      result=1
    fi
    index=$(( ${index} + 1 ))
  done

  echo ${result}
}

function check_letter_position() {
  local player_letter=$1
  local computer_letter=$2
  local result=$3

  if [[ ${player_letter} == ${computer_letter} ]]
  then
    result=0
  fi

  echo ${result}
}

function compare_letters() {
  local player_word=( $1 )
  local computer_word=( $2 )

  local index=0
  while [[ ${index} -lt ${LENGTH} ]]
  do
    local result=2
    result=$( check_letter_presence "${player_word[$index]}" "${computer_word[*]}" ${result} )
    result=$( check_letter_position "${player_word[$index]}" "${computer_word[$index]}" ${result} )

    result_codes[$index]=${result}
    index=$(( ${index} + 1 ))
  done
  echo "${result_codes[*]}"
}

function main() {
  local template_file=$1
  local words_csv_file=$2
  local template=$( cat ${template_file} )
  
  local number_of_words=$( cat ${words_csv_file} | wc -l )
  local random_id=$( jot -r 1 1 ${number_of_words} )
  local random_word=$( grep "^${random_id}|" ${words_csv_file} | cut -d"|" -f2 )
  local computer_word=( `convert_to_array ${random_word}` )

  local index=0
  local num_of_guesses=6
  while [[ ${index} -lt ${num_of_guesses} ]]
  do
    read -p "Enter word: " word 
    local player_word=( `convert_to_array ${word}` )
    local result_codes=( `compare_letters "${player_word[*]}" "${computer_word[*]}"` )
    generate_page "${template}" "${player_word[*]}" "${result_codes[*]}"
    if [[ "${result_codes[*]}" == "0 0 0 0 0" ]]
    then
      echo "SPLENDID!"
      exit
    fi
    index=$(( ${index} + 1 ))
  done

  echo ${random_word}
  echo "Better luck next time, Dude!"
}