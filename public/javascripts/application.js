// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $("#choice ul").idTabs(); 
  $("#performance_one_off").datepicker();
  $("#weekly_a").click(function() {
    $("#performance_one_off").val('');
    return false;
  });
  $("#one_off_a").click(function() {
    $("#performance_weekly").val('');
    return false;
  });

});
