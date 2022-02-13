WORDS=""

function generate_attribute() {
  local attribute=$1
  local attribute_value=$2

  if [[ -z ${attribute_value} ]];
  then
    echo ""
    return
  fi

  echo "${attribute}=\"${attribute_value}\""
}

function generate_tag() {
  local tag=$1
  local attributes="$2"
  local content="$3"

  echo "<${tag} ${attributes}>${content}</${tag}>"
}

function capitalize_letter() {
  local letter=$1

  letter=$( tr '[:lower:]' '[:upper:]' <<< ${letter} )
  echo ${letter}
}

function generate_word() {
  local player_word=( $1 )
  local result_codes=( $2 )
  
  local index=0
  for player_letter in ${player_word[*]}
  do  
    local class="letter"
    if [[ ${result_codes[$index]} == 0 ]]
    then    
      class="${class} green"
    elif [[ ${result_codes[$index]} == 1 ]]
    then    
      class="${class} yellow"
    fi

    player_letter=$( capitalize_letter ${player_letter} )
    local letter_attribute=$( generate_attribute "class" "${class}" )
    local letters+=$( generate_tag "div" "${letter_attribute}" "${player_letter}" )
    index=$(( ${index} + 1 ))
  done

  local div_attribute=$( generate_attribute "class" "word" )
  local div_word=$( generate_tag "div" "${div_attribute}" "${letters}" )

  echo "${div_word}"
}

function generate_page() {
  local template=$1
  local player_word=( $2 )
  local result_codes=( $3 )

  WORDS+=$( generate_word "${player_word[*]}" "${result_codes[*]}" )

  echo "${template}" | sed "s:__WORDS__:${WORDS}:" > html/wordle.html
  open html/wordle.html
}