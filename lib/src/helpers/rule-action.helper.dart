
 // @flow
 import "../interfaces/rules-engine.types.dart" show ProgramRuleAction , EventData ; import "../helpers/rules-engine.helper.dart" show replaceVariables , processValue ; import "run-expression.helper.dart" show runRuleExpression ; import "package:loglevel.dart" as log ; import "d2-utils.helper.dart" show isString ; final getRuleData = /* String */ ( dynamic action , dynamic variablesHash ) { final String actionData = action . data ; var ruleDataEval = actionData ; final nameWithoutBrackets = actionData . replace ( "#{" , "" ) . replace ( "}" , "" ) ; if ( variablesHash [ nameWithoutBrackets ] ) {
 // The variable exists, and is replaced with its corresponding value
 ruleDataEval = variablesHash [ nameWithoutBrackets ] . variableValue ; } else if ( actionData . includes ( "{" ) || actionData . includes ( "d2:" ) ) {
 //Since the value couldnt be looked up directly, and contains a curly brace or a dhis function call,

 //the expression was more complex than replacing a single variable value.

 //Now we will have to make a thorough replacement and separate evaluation to find the correct value:
 ruleDataEval = replaceVariables ( actionData , variablesHash ) ;
 //In a scenario where the data contains a complex expression, evaluate the expression to compile(calculate) the result:
 ruleDataEval = runRuleExpression ( ruleDataEval , actionData , '''actions: ${ action . id}''' , variablesHash ) ; }
 //trimQuotes if found
 if ( ruleDataEval && isString ( ruleDataEval ) ) { ruleDataEval = trimQuotes ( ruleDataEval ) ; } return ruleDataEval ; } ; final buildAssignVariable = ( dynamic variableHash , dynamic variableValue ) { final = variableHash ; return { "variableValue" : variableValue , "variableType" : variableType , "hasValue" : true , "variableEventDate" : "" , "variablePrefix" : variablePrefix ? variablePrefix : "#" , "allValues" : [ variableValue ] } ; } ; final ruleActionEval = /* dynamic */ ( ProgramRuleAction action , dynamic variableHash , EventData eventData ) { final = action ; final dataElementId = dataElement && dataElement . id ; final String actionData = data ? getRuleData ( action , variableHash ) : String ( data ) ; var newVariableHash = variableHash ; if ( identical ( programRuleActionType , "ASSIGN" ) && content ) { final variableToAssign = content . replace ( "#{" , "" ) . replace ( "A{" , "" ) . replace ( "}" , "" ) ; final variableObject = newVariableHash [ variableToAssign ] ; if ( variableObject ) { final = variableObject ; final baseValue = processValue ( actionData , variableType ) ; variableHash [ variableToAssign ] = buildAssignVariable ( variableObject , baseValue ) ; final variableValue = isString ( baseValue ) ? '''${ trimQuotes ( baseValue )}''' : baseValue ; eventData . dataValues [ dataElementId ] = variableValue ; } else { } } return { "variableHash" : variableHash , "eventData" : eventData } ; } ;