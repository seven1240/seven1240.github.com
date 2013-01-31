---
layout: post
title: "Fibonacci 数列"
tags:
  - "erlang"
---

# {{ page.title }}

<div class="tags">
{% for tag in page.tags %}[<a class="tag" href="/tags.html#{{ tag }}">{{ tag }}</a>] {% endfor %}
</div>


看到这个比较有趣的Fibonacci数列对比： <http://fengmk2.github.com/blog/2011/fibonacci/nodejs-python-php-ruby-lua.html> 。

我想知道 Erlang 与他们比起来怎么样，于是测了一下：

参考：<http://en.literateprograms.org/Fibonacci_numbers_(Erlang)>

第3种（Fast tail recursive fibonacci）和第2（Tail recursive fibonacci）种方式结果如下，有趣的是，第2种好像比第3种略好：

	$ time ./a.erl 40 3

	real	0m0.131s
	user	0m0.115s
	sys	0m0.015s
	
	$ time ./a.erl 40 2

	real	0m0.128s
	user	0m0.114s
	sys	0m0.014s


第1种（The fibonacci function），也就是教科书上那最经典的例子，在我机器上运行了18分钟还没完成。分别把N改为30和35，结果为

	$ time ./a.erl 30 1

	real	0m21.611s
	user	0m21.576s
	sys	0m0.033s

	$ time ./a.erl 35 1

	real	3m55.764s
	user	3m55.561s
	sys	0m0.199s


难道第1种方法就这么糟？仔细看了一下算法，发现潜在的有好多重复的计算，于是，改了一下代码，把中间的计算结果都 "cache" 一下，最后结果如下：

	time ./a.erl 40 4

	real	0m0.134s
	user	0m0.118s
	sys	0m0.016s 

比起所谓的“Fast”算法也不差嘛。

为了与其它语言有个比较，我的机器与作者的不一样，因此试了一下C语言的，使用 -O2, gcc version 4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2336.11.00)。

	$ time ./a.out 
	102334155

	real	0m0.069s
	user	0m0.067s
	sys	0m0.001s

比作者的机器快3倍，因此 Erlang 的结果 0.115 * 3 = 0.345，大致比 node.js 略差，比其它脚本语言都好。当然，上面是用 escript 做的，编译成 beam 应该更好一点。完整的脚本如下：

<code>
#!/usr/bin/env escript

%% http://en.literateprograms.org/Fibonacci_numbers_(Erlang)


fibo1(0) -> 0 ;
fibo1(1) -> 1 ;
fibo1(N) when N > 1 -> fibo1(N-1) + fibo1(N-2) .


fibo2_tr( 0, Result, _Next) -> Result ;  %% last recursion output

fibo2_tr( Iter, Result, Next) when Iter > 0 -> fibo2_tr( Iter -1, Next, Result + Next) .

fibo2(N) -> 
	fibo2_tr( N, 0, 1).


fibo3(N) ->
    {Fib, _} = fibo3(N, {1, 1}, {0, 1}),
    Fib.

fibo3(0, _, Pair) -> Pair;
fibo3(N, {Fib1, Fib2}, Pair) when N rem 2 == 0 ->
    SquareFib1 = Fib1*Fib1,
    fibo3(N div 2, {2*Fib1*Fib2 - SquareFib1, SquareFib1 + Fib2*Fib2}, Pair);
fibo3(N, {FibA1, FibA2}=Pair, {FibB1, FibB2}) ->
    fibo3(N-1, Pair, {FibA1*FibB2 + FibB1*(FibA2 - FibA1), FibA1*FibB1 + FibA2*FibB2}).

%% cached improvement of fibo1/1

fibo4(0) -> 0;
fibo4(1) -> 1;
fibo4(N) ->
	N2 = case get(N-2) of
		undefined ->
			X = fibo4(N-2),
			put(N-2, X),
			X;
		X -> X
	end,

	N1 = case get(N-1) of
		undefined ->
			Y = fibo4(N-1),
			put(N-1, Y),
			Y;
		Y -> Y
	end,
	
	% io:format("~p~n", [N2 + N1]),
	N2 + N1.


main([N, "1"]) ->	fibo1(list_to_integer(N));
main([N, "2"]) ->	fibo2(list_to_integer(N));
main([N, "3"]) ->	fibo3(list_to_integer(N));
main([N, "4"]) ->	fibo4(list_to_integer(N)).

</code>

最后，来个金字塔：

<code>
1
1
2
3
5
8
13
21
34
55
89
144
233
377
610
987
1597
2584
4181
6765
10946
17711
28657
46368
75025
121393
196418
317811
514229
832040
1346269
2178309
3524578
5702887
9227465
14930352
24157817
39088169
63245986
102334155

</code>
