---
layout: default
title: {{ site.com }}
---

<div id='tag_cloud'>
{% for tag in site.tags %}
<a href="#{{ tag[0] }}" title="{{ tag[0] }}" rel="{{ tag[1].size }}">{{ tag[0] }}</a>
{% endfor %}
</div>
 
<ul id='tag_list'>
{% for tag in site.tags %}
  <li class='tag_item' id='{{ tag[0] }}'>
    <span class='tag_name'>{{ tag[0] }}</span>
    <span>
      <ul>
      {% for post in tag[1] %}
        <li class='tag_post'><a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a></li>
      {% endfor %}
      </ul>
    </span>
  </li>
{% endfor %}
</ul>
 
<script src="/js/jquery-1.8.0.min.js" type="text/javascript" charset="utf-8"></script> 
<script src="/js/jquery.tagcloud.js" type="text/javascript" charset="utf-8"></script> 
<script language="javascript">
$.fn.tagcloud.defaults = {
    size: {start: 0.9, end: 2, unit: 'em'},
      color: {start: '#e77471', end: '#f62817'}
};
 
$(function () {
    $('#tag_cloud a').tagcloud();
});
</script>