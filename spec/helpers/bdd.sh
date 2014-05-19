# Provides BDD-style test infrastructure

# before: a function that is run once before the 'context' block
#         in which it is defined
# after: a function that is run once after the 'context' block
#        in which it is defined


function describe {
  current_SUT=$1
  current_context=""
  current_spec_description=""
  unset -f before
}


function context {
  run_after_function
  current_context=$1
  current_spec_description=""
}


function it {
  current_spec_description=$1
  run_before_function
  if [ -z $current_context ]; then
    echo_header "$current_SUT $current_spec_description"
  else
    echo_header "$bold$current_SUT$normal $underline$current_context$nounderline $current_spec_description"
  fi
}


# Runs the 'after' function if it exists
function run_after_function {
  determine_function_exists 'after'
  if [ $function_exists == true ]; then
    after
    unset -f after
  fi
}


# Runs the 'before' function if it exists
function run_before_function {
  determine_function_exists 'before'
  if [ $function_exists == true ]; then
    before
    unset -f before
  fi
}

