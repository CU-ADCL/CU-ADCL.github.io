---
title: People 
layout: single 
permalink: /people/
class: people
---

{% comment %}
{% assign sorted = site.people | sort: 'ordering' %}
{% endcomment %}

{% assign roles = "Faculty#Faculty Member&PhD Students#PhD Student" | split: '&' %}

{% for role in roles %}
{% assign rolepair = role | split: '#' %}
<h2>{{rolepair[0]}}</h2>
{% for person in site.people %}
{% if person.status == "current" and person.program == rolepair[1] %}
<div class="person">
<div class="person-basic">
<div class="person-img">
{% if person.picture-link != blank %}
<a href="{{ person.picture-link }}" target="_blank"><img src="{{ site.baseurl }}{{ person.picture }}" alt="{{ person.name }}" title="{{ person.name }}" class="person-img"></a>
{% elsif person.generate-extra-page %}
<a href="{{ site.baseurl }}{{ person.url }}" target="_blank"><img src="{{ site.baseurl }}{{ person.picture }}" alt="{{ person.name }}" title="{{ person.name }}" class="person-img"></a>
{% else %}
<img src="{{ site.baseurl }}{{ person.picture }}" alt="{{ person.name }}" title="{{ person.name }}" class="person-img">
{% endif %}
</div>
<div class="person-info">
<h4>
{% if person.picture-link != blank %}
<a href="{{ person.header-link }}" target="_blank">{{ person.name }}</a>
{% elsif person.generate-extra-page %}
<a href="{{ site.baseurl }}{{ person.url }}" target="_blank">{{ person.name }}</a>
{% else %}
{{ person.name }}
{% endif %}
</h4>
    <p>{{ person.program }}<br>
    <a href="mailto:{{ person.email }}">{{ person.email }}</a></p>
</div>
</div>
<div class="person-bio">
    <p>{{ person.excerpt | markdownify }}</p>
</div>
</div>
{% endif %}
{% endfor %}
{% endfor %}
