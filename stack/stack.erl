-module(stack).
-export([init/0, loop/1, check/1, push/2, pop/1]).

%%starting new process
init() ->
    spawn(?MODULE, loop, [[]]).

%%process loop
loop(State) ->
    receive
        {From, check} ->
            From ! {self(), State},
            loop(State);
        {From, push, Value} ->
            From ! {self(), ok},
            loop([Value | State]);
        {From, pop} ->
            [Value | New_State] = State,
            From ! {self(), Value},
            loop(New_State);
        {From, terminate} ->
            From ! {self(), terminate }
    end.

%%check stack
check(Pid) ->
    Pid ! {self(), check},
    receive
        {Pid, Message} -> Message
    after 3000 ->
        timeout
    end.

%%push value on the stack
push(Pid, Value) ->
    Pid ! {self(), push, Value},
    receive
        {Pid, Message} -> Message
    after 3000 ->
        timeout
    end.

%%return value from stack
pop(Pid) ->
    Pid ! {self(), pop},
    receive
        {Pid, Message} -> Message
    after 3000 ->
        timeout
    end.
