%%%----------------------------------------------------------------------------
%%% File        : test.erl
%%% Description : Test of test functions in erlunit.erl
%%% Version     : 0.2.1/alpha
%%% Status      : alpha
%%% Copyright   : (c) 2010 Eonblast Corporation http://www.eonblast.com
%%% License     : MIT - http://www.opensource.org/licenses/mit-license.php 
%%% Author      : H. Diedrich <hd2010@eonblast.com>
%%% Created     : 18 Apr 2010
%%% Changed     : 23 Apr 2010 - see CHANGES
%%% Tested on   : Erlang R13B01
%%%----------------------------------------------------------------------------
%%%
%%% This program is for development of Erlunit, it tests the Erlunit functions.
%%%
%%% It's not part of what is needed to use Erlunit. It is not a regular Erlunit
%%% test either, it breaks somewhat less controlled.
%%% 
%%% To learn about Erlunit, read sample.erl
%%% 
%%%----------------------------------------------------------------------------
%%%
%%% Usage 
%%%
%%% # erl
%%% 1> {ok,_} = c(erlunit), {ok,_} = c(test), test:run().
%%%  
%%%----------------------------------------------------------------------------
%%%
%%% Mail to hd2010@eonblast.com with questions and suggestions, I will
%%% be happy to answer. - Henning
%%%
%%%----------------------------------------------------------------------------

-module(test).

-vsn("0.2.1/alpha").
-author("H. Diedrich <hd2010@eonblast.com>").
-license("MIT - http://www.opensource.org/licenses/mit-license.php").
-copyright("(c) 2010 Eonblast Corporation http://www.eonblast.com").

%%%----------------------------------------------------------------------------

-export([run/0]).
-import(erlunit).

-compile({nowarn_unused_function, [suite_verbose/0]}).

%-export([one/0]).

-define(VERSION, "0.2.1/alpha").
-define(PROGRAM, "Test-Test").

%%%****************************************************************************
%%% MAIN FUNCTION
%%%****************************************************************************

run() ->

	banner("Testing the test functions"),
	
	erlunit:start(),

	erlunit:echo("Testing the test functions, basically by trying them all."),

	suite_minimal_seq(),
	suite_minimal_msg(),

	suite_complete(),
	suite_complete_inverted(),
	suite_complete_verbose(),
	suite_complete_verbose_mp(),
	suite_complete_mp(),

	erlunit:execute().


%%%****************************************************************************
%%% SAMPLE SUITES
%%%****************************************************************************
%%%
%%%----------------------------------------------------------------------------
%%% #1 Minimal
%%%----------------------------------------------------------------------------

suite_minimal_seq() ->

	erlunit:suite("#1 minimal - sequential"),

	erlunit:true(1 == 1),
	erlunit:equal(fun() -> one() end, 1),
	erlunit:fail(fun() -> 1 / zero() end).

	% using zero() for 0 to avoid Erlang compile time warnings

suite_minimal_msg() ->

	Suite = erlunit:suite("#2 minimal - message passing"),

	Suite ! { true, 1 == 1 },
	Suite ! { equal, 1, 1 }.
%	Suite ! { fail, fun() -> 1 / zero() end }.

	% using zero() for 0 to avoid Erlang compile time warnings

%%%
%%%----------------------------------------------------------------------------
%%% #2: same as above, with names for individual checks
%%%----------------------------------------------------------------------------
%%%

suite_complete() ->

	erlunit:suite("#3 all types of checks - sequential"),

	% true and false
	% -------------------------------
	erlunit:true(true),
	erlunit:true(1 == 1),
	erlunit:not_true(false),
	erlunit:not_true(1 == 2),
	erlunit:not_true(x),
	erlunit:false(false),
	erlunit:false(1 == 0),
	erlunit:not_false(true),
	erlunit:not_false(1 == 1),
	erlunit:not_false(x),

	% true and false / with functions
	% -------------------------------
	erlunit:true(fun() -> true end),
	erlunit:not_true(fun() -> x end),
	erlunit:not_true(fun() -> false end),
	erlunit:false(fun() -> false end),
	erlunit:not_false(fun() -> x end),
	erlunit:not_false(fun() -> true end),

	% equality
	% -------------------------------
	erlunit:equal(1, 1),
	erlunit:equal(a, a),
	erlunit:equal("a", "a"),
	erlunit:not_equal(1, 0),
	erlunit:not_equal(1, true),
	erlunit:not_equal(1, false),
	erlunit:bigger(2, 1),
	erlunit:bigger(a, 1),
	erlunit:bigger(self(), a),
	erlunit:lesser(1, 2),
	erlunit:lesser(1, a),
	erlunit:lesser(1, self()),

	% equality (with functions)
	% -------------------------------
	erlunit:equal(fun() -> 1 end, 1),
	erlunit:not_equal(fun() -> 1 end, 0),
	erlunit:bigger(2, fun() -> 1 end),
	erlunit:lesser(fun() -> 1 end, 2),

	% control always (functions)
	% -------------------------------
	erlunit:pass(fun() -> 1 + 0 end),
	erlunit:fail(fun() -> throw(sic) end),
	erlunit:fail(fun() -> 1 / zero() end),
	erlunit:fail(fun() -> exit(sic) end),
	erlunit:throws(fun() -> throw(sic) end),
	erlunit:error(fun() -> 1 / zero() end),
	erlunit:exits(fun() -> exit(sic) end),
	
	ok.

	% using zero() for 0 to avoid Erlang compile time warnings

%%%
%%%----------------------------------------------------------------------------
%%% #4: same as above, but inverted
%%%----------------------------------------------------------------------------
%%%
%%% Inversion is for testing the test functions. Not for normal use of Erlunit.
%%% It switches the suite so that it counts passes as fails and vice versa.
%%% Crashes are still counted as crashes, as it should be. Remember that crashes
%%% are not at all the same as a fail(), error(), exits() or throws(). Those
%%% latter catch failing test cases, if they fail on purpose or not. Crashes are
%%% failures higher up in the Erlunit mechanics that point to an error in 
%%% Erlunit or a mistake on the part of the developer using Erlunit.

suite_complete_inverted() ->

	erlunit:suite("#4 - All checks/inverted", [inverted]),

	% true and false
	% -------------------------------
	% (inverted)
	erlunit:not_true(true),
	erlunit:not_true(1 == 1),
	erlunit:true(false),
	erlunit:true(1 == 2),
	erlunit:true(x),
	erlunit:not_false(false),
	erlunit:not_false(1 == 0),
	erlunit:false(true),
	erlunit:false(1 == 1),
	erlunit:false(x),

	% true and false / with functions
	% -------------------------------
	% (inverted)
	erlunit:not_true(fun() -> true end),
	erlunit:true(fun() -> x end),
	erlunit:true(fun() -> false end),
	erlunit:not_false(fun() -> false end),
	erlunit:false(fun() -> x end),
	erlunit:false(fun() -> true end),

	% equality
	% -------------------------------
	% (inverted)
	erlunit:not_equal(1, 1),
	erlunit:not_equal(a, a),
	erlunit:not_equal("a", "a"),
	erlunit:equal(1, 0),
	erlunit:equal(1, true),
	erlunit:equal(1, false),
	erlunit:lesser(2, 1),
	erlunit:lesser(a, 1),
	erlunit:lesser(self(), a),
	erlunit:bigger(1, 2),
	erlunit:bigger(1, a),
	erlunit:bigger(1, self()),

	% equality (with functions)
	% -------------------------------
	% (inverted)
	erlunit:not_equal(fun() -> 1 end, 1),
	erlunit:equal(fun() -> 1 end, 0),
	erlunit:lesser(2, fun() -> 1 end),
	erlunit:bigger(fun() -> 1 end, 2),

	% control always (functions)
	% -------------------------------
	% (inverted)
	erlunit:fail(fun() -> 1 + 0 end),
	erlunit:pass(fun() -> throw(sic) end),
	erlunit:pass(fun() -> 1 / zero() end),
	erlunit:pass(fun() -> exit(sic) end),
	erlunit:error(fun() -> throw(sic) end),
	erlunit:exits(fun() -> throw(sic) end),
	erlunit:throws(fun() -> 1 / zero() end),
	erlunit:exits(fun() -> 1 / zero() end),
	erlunit:throws(fun() -> exit(sic) end),
	erlunit:error(fun() -> exit(sic) end),
	
	ok.

	% using zero() for 0 to avoid Erlang compile time warnings

%%%
%%%----------------------------------------------------------------------------
%%% #5: same as above, with names for individual checks = 'verbose'
%%%----------------------------------------------------------------------------
%%%

suite_complete_verbose() ->

	erlunit:suite("#5 - All types, verbose"),

	% true and false
	% -------------------------------
	erlunit:true(true, "True is true!"),
	erlunit:true(1 == 1, "1=1 is true!"),
	erlunit:not_true(false, "False is not true!"),
	erlunit:not_true(1 == 2, "1=2 is not true!"),
	erlunit:not_true(x, "x is not true!"),
	erlunit:false(false, "False is false :-o"),
	erlunit:false(1 == 0, "1=0 is false :-("),
	erlunit:not_false(true, "True is not false :-)"),
	erlunit:not_false(1 == 1, "1=1 is not false :-)"),
	erlunit:not_false(x, "x is not false :-)"),

	% true and false / with functions
	% -------------------------------
	erlunit:true(fun() -> true end, "True is true, w/function"),
	erlunit:not_true(fun() -> x end, "X is not true, w/function"),
	erlunit:not_true(fun() -> false end, "False is not true, w/function"),
	erlunit:false(fun() -> false end, "False is false, w/function"),
	erlunit:not_false(fun() -> x end, "X is not false :-) w/function"),
	erlunit:not_false(fun() -> true end, "True is not false :-) w/function"),

	% equality
	% -------------------------------
	erlunit:equal(1, 1, "1=1 Equality"),
	erlunit:equal(a, a, "Atom Equality"),
	erlunit:equal("a", "a", "String Equality"),
	erlunit:not_equal(1, 0, "Numberic Non-Equality"),
	erlunit:not_equal(1, true, "Type Inequality"),
	erlunit:not_equal(1, false, "Type Inequality"),
	erlunit:bigger(2, 1, "Numeric Bigger"),
	erlunit:bigger(a, 1, "Bigger By Type"),
	erlunit:bigger(self(), a, "Bigger By Type II"),
	erlunit:lesser(1, 2, "Numberic Lesser"),
	erlunit:lesser(1, a, "Number lesser than Atom"),
	erlunit:lesser(1, self(), "Type of Number smaller than Pid"),

	% equality (with functions)
	% -------------------------------
	erlunit:equal(fun() -> 1 end, 1, "1=1 Equality, w/function"),
	erlunit:not_equal(fun() -> 1 end, 0, "1=0 Inequality, w/function"),
	erlunit:bigger(2, fun() -> 1 end, "2>1, w/function"),
	erlunit:lesser(fun() -> 1 end, 2, "1<2, w/function"),

	% control always (functions)
	% -------------------------------
	erlunit:pass(fun() -> 1 + 0 end, "Pass of Calculation, w/function"),
	erlunit:fail(fun() -> throw(sic) end, "Fail by throw, w/function"),
	erlunit:fail(fun() -> 1 / zero() end, "Fail by error, w/function"),
	erlunit:fail(fun() -> exit(sic) end, "Fail by exit, w/function"),
	erlunit:throws(fun() -> throw(sic) end, "Control Exception, w/function"),
	erlunit:error(fun() -> 1 / zero() end, "Control Error Condition, w/function"),
	erlunit:exits(fun() -> exit(sic) end, "Control Exit, w/function"),
	
	ok.

	% using zero() for 0 to avoid Erlang compile time warnings
%%%
%%%
%%%----------------------------------------------------------------------------
%%% #6: same as above, names for every check, but message passing style
%%%----------------------------------------------------------------------------
%%%

suite_complete_verbose_mp() ->

	Suite = erlunit:suite( "#6 - All types, verbose, message passing style" ),

	% true and false
	% -------------------------------
	Suite ! { true, true, "True is true!" },
	Suite ! { true, 1 == 1, "1=1 is true!" },
	Suite ! { not_true, false, "False is not true!" },
	Suite ! { not_true, 1 == 2, "1=2 is not true!" },
	Suite ! { not_true, x, "x is not true!" },
	Suite ! { false, false, "False is false :-o" },
	Suite ! { false, 1 == 0, "1=0 is false :-(" },
	Suite ! { not_false, true, "True is not false :-)" },
	Suite ! { not_false, 1 == 1, "1=1 is not false :-)" },
	Suite ! { not_false, x, "x is not false :-)" },

	% true and false / with functions
	% -------------------------------
	Suite ! { true, fun() -> true end, "True is true, w/function" },
	Suite ! { not_true, fun() -> x end, "X is not true, w/function" },
	Suite ! { not_true, fun() -> false end, "False is not true, w/function" },
	Suite ! { false, fun() -> false end, "False is false, w/function" },
	Suite ! { not_false, fun() -> x end, "X is not false :-) w/function" },
	Suite ! { not_false, fun() -> true end, "True is not false :-) w/function" },

	% equality
	% -------------------------------
	Suite ! { equal, 1, 1, "1=1 Equality" },
	Suite ! { equal, a, a, "Atom Equality" },
	Suite ! { equal, "a", "a", "String Equality" },
	Suite ! { not_equal, 1, 0, "Numberic Non-Equality" },
	Suite ! { not_equal, 1, true, "Type Inequality" },
	Suite ! { not_equal, 1, false, "Type Inequality" },
	Suite ! { bigger, 2, 1, "Numeric Bigger" },
	Suite ! { bigger, a, 1, "Bigger By Type" },
	Suite ! { bigger, self(), a, "Bigger By Type II" },
	Suite ! { lesser, 1, 2, "Numberic Lesser" },
	Suite ! { lesser, 1, a, "Number lesser than Atom" },
	Suite ! { lesser, 1, self(), "Type of Number smaller than Pid" },

	% equality (with functions)
	% -------------------------------
	Suite ! { equal, fun() -> 1 end, 1, "1=1 Equality, w/function" },
	Suite ! { not_equal, fun() -> 1 end, 0, "1=0 Inequality, w/function" },
	Suite ! { bigger, 2, fun() -> 1 end, "2>1, w/function" },
	Suite ! { lesser, fun() -> 1 end, 2, "1<2, w/function" },

	% control always (functions)
	% -------------------------------
	Suite ! { pass, fun() -> 1 + 0 end, "Pass of Calculation, w/function" },
	Suite ! { fail, fun() -> throw(sic) end, "Fail by throw, w/function" },
	Suite ! { fail, fun() -> 1 / zero() end, "Fail by error, w/function" },
	Suite ! { fail, fun() -> exit(sic) end, "Fail by exit, w/function" },
	Suite ! { throws, fun() -> throw(sic) end, "Control Exception, w/function" },
	Suite ! { error, fun() -> 1 / zero() end, "Control Error Condition, w/function" },
	Suite ! { exits, fun() -> exit(sic) end, "Control Exit, w/function" },
	
	ok.

	% using zero() for 0 to avoid Erlang compile time warnings
%%%
%%%
%%%----------------------------------------------------------------------------
%%% #7: same as above, but without text element
%%%----------------------------------------------------------------------------
%%%
suite_complete_mp() ->

	Suite = erlunit:suite( "#7 - All types, non-verbose, message passing style" ),

	% true and false
	% -------------------------------
	Suite ! { true, true },
	Suite ! { true, 1 == 1 },
	Suite ! { not_true, false },
	Suite ! { not_true, 1 == 2 },
	Suite ! { not_true, x },
	Suite ! { false, false },
	Suite ! { false, 1 == 0 },
	Suite ! { not_false, true },
	Suite ! { not_false, 1 == 1 },
	Suite ! { not_false, x },

	% true and false / with functions
	% -------------------------------
	Suite ! { true, fun() -> true end },
	Suite ! { not_true, fun() -> x end },
	Suite ! { not_true, fun() -> false end },
	Suite ! { false, fun() -> false end },
	Suite ! { not_false, fun() -> x end },
	Suite ! { not_false, fun() -> true end },

	% equality
	% -------------------------------
	Suite ! { equal, 1, 1 },
	Suite ! { equal, a, a },
	Suite ! { equal, "a", "a" },
	Suite ! { not_equal, 1, 0 },
	Suite ! { not_equal, 1, true },
	Suite ! { not_equal, 1, false },
	Suite ! { bigger, 2, 1 },
	Suite ! { bigger, a, 1 },
	Suite ! { bigger, self(), a },
	Suite ! { lesser, 1, 2 },
	Suite ! { lesser, 1, a },
	Suite ! { lesser, 1, self() },

	% equality (with functions)
	% -------------------------------
	Suite ! { equal, fun() -> 1 end, 1 },
	Suite ! { not_equal, fun() -> 1 end, 0 },
	Suite ! { bigger, 2, fun() -> 1 end },
	Suite ! { lesser, fun() -> 1 end, 2 },

	% control always (functions)
	% -------------------------------
	Suite ! { pass, fun() -> 1 + 0 end },
	Suite ! { fail, fun() -> throw(sic) end },
	Suite ! { fail, fun() -> 1 / zero() end },
	Suite ! { fail, fun() -> exit(sic) end },
	Suite ! { throws, fun() -> throw(sic) end },
	Suite ! { error, fun() -> 1 / zero() end },
	Suite ! { exits, fun() -> exit(sic) end },
	
	ok.

	% using zero() for 0 to avoid Erlang compile time warnings
%%%
%%%----------------------------------------------------------------------------
%%% #2: same as above, with names for individual checks
%%%----------------------------------------------------------------------------
%%%
%%% NOT YET USED

suite_verbose() ->

	erlunit:suite("#2 - Very Simple / verbose"),
	erlunit:echo("Suite #2 gives names to individual checks"),

	erlunit:true(1 == 1, "One Equals One"),
	erlunit:false(1 == 0, "One Equals Zero"),

	erlunit:not_true(1 == 2, "One Does Not Equal Two"),
	erlunit:not_false(foo, "Foo Is Not True"),
	erlunit:not_false(1 == 1, "One Not Not Equals One"),
	erlunit:not_false(bar, "Bar Is Not False"),

	erlunit:equal(1, 1, "Once More Equality"),
	erlunit:not_equal(1, 0, "And Non-Equality"),

	erlunit:pass(fun() -> 1 + 0 end, "Trivial Fun"),
	erlunit:fail(fun() -> 1 / zero() end, "Div By Zero").

	% using zero() for 0 to avoid Erlang compile time warnings	

%%%****************************************************************************
%%% UTILITY
%%%****************************************************************************
%%%
%%%----------------------------------------------------------------------------
%%% This is used to avoid Erlang compile time warnings.
%%%----------------------------------------------------------------------------

zero() -> 0.

%%%
%%%----------------------------------------------------------------------------
%%% This is used to test the automatic execution of funs in payload/1.
%%%----------------------------------------------------------------------------

one() -> 1.

%%%****************************************************************************
%%% SCREEN UTILITY
%%%****************************************************************************
%%%
%%% This duplicates utility source in sample.erl

-define(WIDTH, 75).
-define(DASHLINE, string:chars($*, ?WIDTH)).

%%%----------------------------------------------------------------------------
%%% Banner
%%%----------------------------------------------------------------------------
%%%
%%% Centered banner with text only

banner(Text) ->

    io:format("~s~n~s~s~n~s~n",[?DASHLINE, center_indent(Text, ?WIDTH), Text,?DASHLINE]).

%%%----------------------------------------------------------------------------
%%% Centering a headline
%%%----------------------------------------------------------------------------

center_indent(Text, Width) ->
	string:chars(32, erlang:max(0, trunc((Width - length(Text)) / 2))).
	

%%%----------------------------------------------------------------------------
%%% Further reading
%%%----------------------------------------------------------------------------
%%%
%%% The actual test functions are in erlunit.erl
%%% View online at http://github.com/hdiedrich/erlunit/blob/master/erlunit.erl