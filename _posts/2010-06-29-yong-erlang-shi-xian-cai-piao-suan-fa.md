---
layout: post
title: "用 Erlang 实现彩票算法"
tags:
  - "erlang"
---


我们需要解决的问题是 -- 选择一个最好的客服代表为客户服务，又不失公平。

首先，我们有一个数组列出了所有的客服代表，以及他们的积分（score）。当然，该积分根据客服代表的历史表现评定的。服务越好的客户代码积分越高。

要解决该问题，有一个著名和算法称为“彩票算法”。它的基本原理是，根据每个人的积分发放彩票，积分高的人得到的彩票数量就多，如果每张彩票中奖的概率是相等的，那么在一轮选择中，显然积分越高的人会有更高的概率赢得客户（中奖），而在 N 轮选择中，积分越高的人赢得的客户就越多。

说得再具体一点，假设有三个客服代表，A1、A2和A3，他们的积分分别是 6、3、1。则第一个客户到来时，A1最有可能赢得这个客户。当然，也不一定，因为我们这里的算法是基于概率的，也可能该客户让A3获得了，称为优先级反转。不过，无法如何，如果有10个客户到来时，我们希望他们分得的客户分别是6、3、1。

算法的实现，我们把上面的例子说得再通用一点，假设A1、A2、A3分别持有彩票a1、a2、a3，那么彩票的总数就是 a1 + a2 + a3 = N，他们分别持有的彩票号码如下图：


<code>
    |    A1        |         A2                |        A3              |  
    |  1, 2 .. a1  | a1+1, a1 + 2 .... a1 + a2 | a1+a2+1..... a1+a2+a3=N|
</code>

那么我们如何决定谁中奖呢？首先，我们需要确定一个中奖号码，从 1 到 N 中取一个随机数，把该数作为中奖号码。具体代码如下：

<code>

who_win_the_lottery([], TotalLotterys, _LotteryNumber) ->
	no_winner;
who_win_the_lottery([{Agent, Lotteries} | Agents], TotalLotteries, LotteryNumber) ->

	% Note: List of {Agent, Lotteries} pairs already in reverse order

	RestLotteries = TotalLotteries - Lotteries,
	case LotteryNumber > RestLotteries of
		true -> Agent;  % congratulations! you win!
		false ->
			who_win_the_lottery(Agents, RestLotteries, LotteryNumber)
	end.

</code>

思路是，给定一个列表，从最后一个客服代表开始算，如果中奖号码不在最后一个人手中，则往前查找一个，直至找到中奖号码。算法中，根据“等概率”的特性，列表中客服代表的排列顺序是无关的，但为了与上面图中给出的顺序统一，可以先将列表翻转 (lists:reverse)，下面代码先生成一张中奖彩票 LotteryNumber，然后判断谁中奖。

<code>

decide_winner() ->
	
	LotteryNumber = case TotalLotteries of
		0 -> 1;  % avoid random:uniform(0) generate exceptions
		_ -> random:uniform(TotalLotteries)
	end,

	io:format("LotteryNumber: ~p~n", [LotteryNumber]),
	
        AgentList = [{agent1, 6}, {agent2, 3}, {agent3, 1}],
        TotalLotteries = 10,

        % lists:revert(AgentList)

	Winner = who_win_the_lottery(AgentList, TotalLotteries, LotteryNumber),
	io:format("Winner: ~p~n", [Winner]),
	Winner.
</code>

需要指出，这种基本概率的算法是不可靠的，也就是说根据上面的数据，在10次实验中我们期望获得 6、3、1，但实际可能是5、3、2。如果数据量比较大，结果就比较相近了。
