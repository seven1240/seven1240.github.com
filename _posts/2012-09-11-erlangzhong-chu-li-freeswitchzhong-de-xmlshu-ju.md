---
layout: default
title: "Erlang中处理FreeSWITCH中的XML数据"
---

# {{ page.title }}

在 Erlang 中处理XML, [mryufeng](http://mryufeng.iteye.com/blog/363049) 大侠提到两种方案，从别是Erlang自带的 xmerl 和 ejabered 带的 xml 处理器。我只用过前者，应该说还比较顺手，但数据结构看起来确实比较累。今天拿FreeSWITCH的会议数据试了一把：

获取 xml 数据，在 fs\_cli 中是这样的


	freeswitch@Dus-MacBook-Pro.local> conference 3000 xml_list 

	<?xml version="1.0"?>
	<conferences>
	  <conference name="3000" member-count="1" rate="8000" uuid="c5022778-dce8-4d51-8c5b-51e01ace6ecd" running="true" answered="true" enforce_min="true" dynamic="true" exit_sound="true" enter_sound="true" run_time="176">
	    <members>
	      <member type="caller">
	        <id>14</id>
	        <flags>
	          <can_hear>true</can_hear>
	          <can_speak>true</can_speak>
	          <mute_detect>false</mute_detect>
	          <talking>true</talking>
	          <has_video>false</has_video>
	          <video_bridge>false</video_bridge>
	          <has_floor>true</has_floor>
	          <is_moderator>false</is_moderator>
	          <end_conference>false</end_conference>
	        </flags>
	        <uuid>8c3e34ab-bacd-44ff-9f8d-b8f37aa0bdf6</uuid>
	        <caller_id_name>1000</caller_id_name>
	        <caller_id_number>1000</caller_id_number>
	        <join_time>176</join_time>
	        <last_talking>0</last_talking>
	        <energy>300</energy>
	        <volume_in>0</volume_in>
	        <volume_out>0</volume_out>
	        <output-volume>0</output-volume>
	        <input-volume>0</input-volume>
	        <auto-adjusted-input-volume>0</auto-adjusted-input-volume>
	      </member>
	    </members>
	  </conference>
	</conferences>

在 erlang 中这样实现

	(ocean@localhost)29> {ok, XML} = freeswitch:api('freeswitch@localhost', conference, "xml_list").
	{ok,<<"<?xml version=\"1.0\"?>\n<conferences>\n  <conference name=\"3000\" member-count=\"1\" rate=\"8000\" uuid=\"c5022778-dc"...>>}

获取的 XML 数据后，使用 xmerl\_scan 解析XML,生成一个Doc：

	(ocean@localhost)30> {Doc1, _} = xmerl_scan:string(binary_to_list(XML)).                        
	{{xmlElement,conferences,conferences,[],
	             {xmlNamespace,[],[]},
	             [],1,[],
	             [{xmlText,[{conferences,1}],1,[],"\n  ",text},
	              {xmlElement,conference,conference,[],
	                          {xmlNamespace,[],[]},
	                          [{conferences,1}],
	                          2,
	                          [{xmlAttribute,name,[],[],[],
	                                         [{conference,...},{...}],
	                                         1,[],...},
	                           {xmlAttribute,'member-count',[],[],[],[{...}|...],2,...},
	                           {xmlAttribute,rate,[],[],[],[...],...},
	                           {xmlAttribute,uuid,[],[],[],...},
	                           {xmlAttribute,running,[],[],...},
	                           {xmlAttribute,answered,[],...},
	                           {xmlAttribute,enforce_min,...},
	                           {xmlAttribute,...},
	                           {...}|...],
	                          [{xmlText,[{conference,2},{conferences,1}],
	                                    1,[],"\n    ",text},
	                           {xmlElement,members,members,[],{xmlNamespace,...},[...],...},
	                           {xmlText,[{conference,2},{conferences,...}],3,[],[...],...}],
	                          [],"/Users/dujinfang/workspace/ocean",undeclared},
	              {xmlText,[{conferences,1}],3,[],"\n",text}],
	             [],"/Users/dujinfang/workspace/ocean",undeclared},
	 []}

好处是可以使用 XPath:

	(ocean@localhost)39> 
	(ocean@localhost)39> xmerl_xpath:string("/conferences/conference", Doc1).     
	[{xmlElement,conference,conference,[],
	             {xmlNamespace,[],[]},
	             [{conferences,1}],
	             2,
	             [{xmlAttribute,name,[],[],[],
	                            [{conference,2},{conferences,1}],
	                            1,[],"3000",false},
	              {xmlAttribute,'member-count',[],[],[],
	                            [{conference,2},{conferences,1}],
	                            2,[],"1",false},
	              {xmlAttribute,rate,[],[],[],
	                            [{conference,2},{conferences,1}],
	                            3,[],"8000",false},
	              {xmlAttribute,uuid,[],[],[],
	                            [{conference,2},{conferences,1}],
	                            4,[],"c5022778-dce8-4d51-8c5b-51e01ace6ecd",false},
	              {xmlAttribute,running,[],[],[],
	                            [{conference,2},{conferences,1}],
	                            5,[],"true",false},
	              {xmlAttribute,answered,[],[],[],
	                            [{conference,2},{conferences,1}],
	                            6,[],"true",false},
	              {xmlAttribute,enforce_min,[],[],[],
	                            [{conference,2},{conferences,1}],
	                            7,[],"true",false},
	              {xmlAttribute,dynamic,[],[],[],
	                            [{conference,2},{conferences,1}],
	                            8,[],"true",false},
	              {xmlAttribute,exit_sound,[],[],[],
	                            [{conference,2},{conferences,1}],
	                            9,[],"true",false},
	              {xmlAttribute,enter_sound,[],[],[],
	                            [{conference,2},{conferences,1}],
	                            10,[],"true",false},
	              {xmlAttribute,run_time,[],[],[],
	                            [{conference,2},{conferences,...}],
	                            11,[],
	                            [...],...}],
	             [{xmlText,[{conference,2},{conferences,1}],
	                       1,[],"\n    ",text},
	              {xmlElement,members,members,[],
	                          {xmlNamespace,[],[]},
	                          [{conference,2},{conferences,1}],
	                          2,[],
	                          [{xmlText,[{members,2},{conference,2},{conferences,1}],
	                                    1,[],"\n      ",text},
	                           {xmlElement,member,member,[],{xmlNamespace,...},[...],...},
	                           {xmlText,[{members,2},{conference,...},{...}],
	                                    3,[],
	                                    [...],...}],
	                          [],"/Users/dujinfang/workspace/ocean",undeclared},
	              {xmlText,[{conference,2},{conferences,1}],3,[],"\n  ",text}],
	             [],"/Users/dujinfang/workspace/ocean",undeclared}]

或者取到某个属性：


	(ocean@localhost)40> NameAttr = xmerl_xpath:string("/conferences/conference/@name", Doc1).
	[{xmlAttribute,name,[],[],[],
	               [{conference,2},{conferences,1}],
	               1,[],"3000",false}]

那么最终如何取得 Name = “3000" 呢？ 在 Erlang shell 环境下要用 rr 函数载入 record 定义，如果在程序中则需要使用 -include() 装入：


	(ocean@localhost)44> rr("/usr/local/lib/erlang/lib/xmerl-1.3.1/include/xmerl.hrl").
	[xmerl_event,xmerl_fun_states,xmerl_scanner,xmlAttribute,
	 xmlComment,xmlContext,xmlDecl,xmlDocument,xmlElement,
	 xmlNamespace,xmlNode,xmlNsNode,xmlObj,xmlPI,xmlText]

它实际上装入了所有相关的 record 定义，一些典型的定义如下：


	%% XML declaration 
	-record(xmlDecl,{ 
	          vsn,        % string() XML version 
	          encoding,   % string() Character encoding 
	          standalone, % (yes | no) 
	          attributes  % [#xmlAttribute()] Other attributes than above 
	         }). 

	%% Attribute 
	-record(xmlAttribute,{ 
	          name,            % atom() 
	          expanded_name=[],% atom() | {string(),atom()} 
	          nsinfo = [],     % {Prefix, Local} | [] 
	          namespace = [],  % inherits the element's namespace 
	          parents = [],    % [{atom(),integer()}] 
	          pos,             % integer() 
	          language = [],   % inherits the element's language 
	          value,           % IOlist() | atom() | integer() 
	          normalized       % atom() one of (true | false) 
	         }). 

	%% namespace record 
	-record(xmlNamespace,{ 
	          default = [], 
	          nodes = [] 
	         }). 

	%% namespace node - i.e. a {Prefix, URI} pair 
	%% TODO: these are not currently used?? /RC 
	-record(xmlNsNode,{ 
	          prefix, 
	          uri = [] 
	         }). 

	%% XML Element 
	%% content = [#xmlElement()|#xmlText()|#xmlPI()|#xmlComment()|#xmlDecl()]
	-record(xmlElement,{ 
	          name,                 % atom() 
	          expanded_name = [],   % string() | {URI,Local} | {"xmlns",Local} 
	          nsinfo = [],          % {Prefix, Local} | [] 
	          namespace=#xmlNamespace{}, 
	          parents = [],         % [{atom(),integer()}] 
	          pos,                  % integer() 
	          attributes = [],      % [#xmlAttribute()] 
	          content = [], 
	          language = "",        % string() 
	          xmlbase="",           % string() XML Base path, for relative URI:s 
	          elementdef=undeclared % atom(), one of [undeclared | prolog | external | element]
	         }). 
	%% plain text 
	%% IOlist = [char() | binary () | IOlist] 
	-record(xmlText,{ 
	          parents = [], % [{atom(),integer()}] 
	          pos,          % integer() 
	          language = [],% inherits the element's language 
	          value,        % IOlist() 
	          type = text   % atom() one of (text|cdata) 
	         }). 

	%% plain text 
	-record(xmlComment,{ 
	          parents = [],  % [{atom(),integer()}] 
	          pos,           % integer() 
	          language = [], % inherits the element's language 
	          value          % IOlist() 
	         }). 

这些定义看起来比较清晰，但读者看上面解析完毕的 Doc 便知，看起来还是很累眼的。

OK，言归正传，接下来可以进行匹配了：


	[#xmlAttribute{value = Name}] = NameAttr.
	[#xmlAttribute{name = name,expanded_name = [],nsinfo = [],
	               namespace = [],
	               parents = [{conference,2},{conferences,1}],
	               pos = 1,language = [],value = "3000",normalized = false}]

终于，得到我们要的了：

	(ocean@localhost)50> Name.
	"3000"


如果要得到更多的属性，则要重复使用上面的匹配模式，可者写成函数处理，总是感觉还不太方便。网上搜了一下，看有的网友提到 mochiweb_http 也可以处理，试了一下果然简洁很多。


	(ocean@localhost)91> Parsed = mochiweb_html:parse(XML1).
	<<"conferences">>,[],
	 [{<<"conference">>,
	   [{<<"name">>,<<"3000">>},
	    {<<"member-count">>,<<"1">>},
	    {<<"rate">>,<<"8000">>},
	    {<<"uuid">>,<<"c5022778-dce8-4d51-8c5b-51e01ace6ecd">>},
	    {<<"running">>,<<"true">>},
	    {<<"answered">>,<<"true">>},
	    {<<"enforce_min">>,<<"true">>},
	    {<<"dynamic">>,<<"true">>},
	    {<<"exit_sound">>,<<"true">>},
	    {<<"enter_sound">>,<<"true">>},
	    {<<"run_time">>,<<"10">>}],
	   [{<<"members">>,[],
	     [{<<"member">>,
	       [{<<"type">>,<<"caller">>}],
	       [{<<"id">>,[],[<<"14">>]},
	        {<<"flags">>,[],
	         [{<<"can_hear">>,[],[<<"true">>]},
	          {<<"can_speak">>,[],[<<"true">>]},
	          {<<"mute_detect">>,[],[<<"false">>]},
	          {<<"talking">>,[],[<<"true">>]},
	          {<<"has_video">>,[],[<<...>>]},
	          {<<"video_br"...>>,[],[...]},
	          {<<"has_"...>>,[],...},
	          {<<...>>,...},
	          {...}]},
	        {<<"uuid">>,[],[<<"8c3e34ab-bacd-44ff-9f8d-b8f3"...>>]},
	        {<<"caller_id_name">>,[],[<<"1000">>]},
	        {<<"caller_id_number">>,[],[<<"1000">>]},
	        {<<"join_time">>,[],[<<"10">>]},
	        {<<"last_talking">>,[],[<<"1">>]},
	        {<<"energy">>,[],[<<"300">>]},
	        {<<"volume_in">>,[],[<<"0">>]},
	        {<<"volume_out">>,[],[<<...>>]},
	        {<<"output-v"...>>,[],[...]},
	        {<<"inpu"...>>,[],...},
	        {<<...>>,...}]}]}]}]}


其格式是

	{ 标签, 属性, 文本}

很容易用以下程序转换成标准的 proplist:


	-module(t).
	-compile(export_all).

	pp({Tag, Attrs, Texts}) ->
		[
			{tag, Tag},
			{attrs, Attrs},
			{text, case Texts of
				[Text] when is_binary(Text) -> Text;
				_ ->
					[ pp(Text)  || Text <- Texts]
			end}
		].



执行一下：

	(ocean@localhost)92> t:pp(Parsed).    
	[{tag,<<"conferences">>},
	 {attrs,[]},
	 {text,[[{tag,<<"conference">>},
	         {attrs,[{<<"name">>,<<"3000">>},
	                 {<<"member-count">>,<<"2">>},
	                 {<<"rate">>,<<"8000">>},
	                 {<<"uuid">>,<<"c5022778-dce8-4d51-8c5b-51e01ace6ecd">>},
	                 {<<"running">>,<<"true">>},
	                 {<<"answered">>,<<"true">>},
	                 {<<"enforce_min">>,<<"true">>},
	                 {<<"dynamic">>,<<"true">>},
	                 {<<"exit_sound">>,<<"true">>},
	                 {<<"enter_sound">>,<<"true">>},
	                 {<<"run_time">>,<<"5847">>}]},
	         {text,[[{tag,<<"members">>},
	                 {attrs,[]},
	                 {text,[[{tag,<<"member">>},
	                         {attrs,[{<<"type">>,<<"caller">>}]},
	                         {text,[[{tag,<<"id">>},{attrs,[]},{text,<<...>>}],
	                                [{tag,<<"flag"...>>},{attrs,[]},{text,...}],
	                                [{tag,<<...>>},{attrs,...},{...}],
	                                [{tag,...},{...}|...],
	                                [{...}|...],
	                                [...]|...]}],
	                        [{tag,<<"member">>},
	                         {attrs,[{<<"type">>,<<"caller">>}]},
	                         {text,[[{tag,<<"id">>},{attrs,[]},{text,...}],
	                                [{tag,<<...>>},{attrs,...},{...}],
	                                [{tag,...},{...}|...],
	                                [{...}|...],
	                                [...]|...]}]]}]]}]]}]


转换完毕后很容易生成JSON:

    mochijson2:encode(t:pp(Parsed))

或输出到 ErlyDTL 模板中：


	<div id = "test">
	<ul>
		{% for c in conference_object.text %}
			<li> Conference
				{{ c.attrs.name }}
				{{ c.attrs.uuid }}
				<ul>Members
				{% for members in c.text %}
					{% for member in members.text %}
						<li>
						{% for m in member.text %}
							{% if m.tag == "id" %}
								id = {{ m.text }}
							{% endif %}
							{% if m.tag == "flags" %}
								{% for flag in m.text %}
									{{ flag.tag }} : {{ flag.text }}
								{% endfor %}

							{% endif %}
						{% endfor %}
						</li>
					{% endfor %}
				{% endfor %}
			</li>

		{% endfor %}

	</ul>

	</div>

这样，视图模板写起来比较累，生成的Json也不好看，索性，手工弄一把吧（简单起见，没有使用尾递归）：

    p_conference({<<"conferences">>, [], Conferences}) ->
        p_conference(Conferences);

    p_conference({<<"conference">>, Attrs, Members}) ->
        Attrs ++ [{members, p_member(Members)}];

    p_conference(Conferences) ->
        [p_conference(Conference) || Conference <- Conferences].

    p_member([{<<"members">>, [], Members}]) ->
        [ p_member(Member) || Member <- Members];

    p_member({<<"member">>, Attrs, Texts}) ->
        Attrs ++ [p_texts(Text) || Text <- Texts].

    p_texts({<<"flags">>, [], Flags}) ->
        {flags, [ {K, V} || {K, [], V} <- Flags]};

    p_texts({K, [], V}) -> {K, V}.

最后生成的数据格式如下：

    rp(t:p_conference(Parsed)).
    [[{<<"name">>,<<"3000">>},
    {<<"member-count">>,<<"1">>},
    {<<"rate">>,<<"8000">>},
    {<<"uuid">>,<<"23e7ba1c-4eb8-4511-8031-1eb2bf49aaf6">>},
    {<<"running">>,<<"true">>},
    {<<"answered">>,<<"true">>},
    {<<"enforce_min">>,<<"true">>},
    {<<"dynamic">>,<<"true">>},
    {<<"exit_sound">>,<<"true">>},
    {<<"enter_sound">>,<<"true">>},
    {<<"run_time">>,<<"5">>},
    {members,[[{<<"type">>,<<"caller">>},
               {<<"id">>,[<<"19">>]},
               {flags,[{<<"can_hear">>,[<<"true">>]},
                       {<<"can_speak">>,[<<"true">>]},
                       {<<"mute_detect">>,[<<"false">>]},
                       {<<"talking">>,[<<"false">>]},
                       {<<"has_video">>,[<<"false">>]},
                       {<<"video_bridge">>,[<<"false">>]},
                       {<<"has_floor">>,[<<"true">>]},
                       {<<"is_moderator">>,[<<"false">>]},
                       {<<"end_conference">>,[<<"false">>]}]},
               {<<"uuid">>,[<<"62b51f04-b305-41e0-b7e0-791b013f1639">>]},
               {<<"caller_id_name">>,[<<"1000">>]},
               {<<"caller_id_number">>,[<<"1000">>]},
               {<<"join_time">>,[<<"5">>]},
               {<<"last_talking">>,[<<"N/A">>]},
               {<<"energy">>,[<<"300">>]},
               {<<"volume_in">>,[<<"0">>]},
               {<<"volume_out">>,[<<"0">>]},
               {<<"output-volume">>,[<<"0">>]},
               {<<"input-volume">>,[<<"0">>]},
               {<<"auto-adjusted-input-volume">>,[<<"0">>]}]]}]]
    ok

模板也简单也很多：

    <div id = "test">
    <ul>
      {% for c in conference_object %}
        <li> Conference
          {{ c.name }}
          {{ c.uuid }}
          <ul>Members
          {% for m in c.members %}
              <li>
                id = {{ m.id }}
                {% for k, v in m.flags %}
                {{ k }}: {{ v}}
                {% endfor %}
              </li>       
          {% endfor %}
          </ul>
        </li>

      {% endfor %}

    </ul>

    </div>
