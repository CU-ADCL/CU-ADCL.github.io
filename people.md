---
title: People 
layout: single 
permalink: /people/
class: people
---

{% assign sorted = site.people | sort: 'ordering' %}
{% for people in sorted %}
{% if people.status == "current" %}
<div class="flex-container">
<div class="flex-child disappearing">
{% if people.picture-link != blank %}
<a href="{{ people.picture-link }}" target="_blank"><img src="{{ site.baseurl }}{{ people.picture }}" alt="{{ people.name }}" title="{{ people.name }}"></a>
{% elsif people.generate-extra-page %}
<a href="{{ site.baseurl }}{{ people.url }}" target="_blank"><img src="{{ site.baseurl }}{{ people.picture }}" alt="{{ people.name }}" title="{{ people.name }}"></a>
{% else %}
<img src="{{ site.baseurl }}{{ people.picture }}" alt="{{ people.name }}" title="{{ people.name }}">
{% endif %}
</div>
<div class="flex-child">
<h3>
{% if people.picture-link != blank %}
<a href="{{ people.header-link }}" target="_blank">{{ people.name }}</a>
{% elsif people.generate-extra-page %}
<a href="{{ site.baseurl }}{{ people.url }}" target="_blank">{{ people.name }}</a>
{% else %}
{{ people.name }}
{% endif %}
</h3>
<div class="flex-child">
    <p>{{ people.program }}, 
    <a href="mailto:{{ people.email }}">{{ people.email }}</a>
    {{ people.excerpt | markdownify }}</p>
</div>
</div>
</div>
{% endif %}
{% endfor %}
