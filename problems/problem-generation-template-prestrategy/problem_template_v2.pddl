; Title: Problem Generation Template for Pre-strategy FlowFree Domain
; Author: Aditi Basu

;; !pre-parsing:{type: "jinja2", data:"p1_8x8_v2.json"}

(define (problem {{data.name}})
    (:domain FlowFree)

    (:objects 
        {{data.dots|join(' ')}} - dot
        {% for i in range(data.size) %}
        {%- for j in range(data.size) -%} node{{i+1}}-{{j+1}} {% endfor %}- node 
        {% endfor %}
    )

    (:init 
        ; head relations
        {% for colour, node in data.init.heads.items() -%}
        (head node{{node}} {{colour}}) {% endfor %}

        ; filled relations
        ; the 'starting' positions
        {% for colour, node in data.init.heads.items() -%}
        (filled node{{node}} {{colour}}) {% endfor %}

        ; the destinations
        {% for colour, node in data.init.nonheads.items() -%}
        (filled node{{node}} {{colour}}) {% endfor %}

        ; select first colour
        (selected r)

        ; empty relations - CHANGE PER PROBLEM
        {%- for i in range(data.size) %}
        {%- for j in range(data.size) -%}
        {% if ( ((i+1)~'-'~(j+1) not in data.init.heads.values()) and
                ((i+1)~'-'~(j+1) not in data.init.nonheads.values()) ) %}
        (empty node{{i+1}}-{{j+1}}) 
        {%- endif -%}
        {% endfor %}
        {% endfor %}

        ; adjacent relations - CHANGE PER GRID SIZE
        {% for i in range(data.size) %}
        {%- for j in range(data.size) -%}
        {%- if (j+2) < (data.size + 1) -%} (adjacent node{{i+1}}-{{j+1}} node{{i+1}}-{{j+2}}) {% endif %}
        {%- if j > 0 -%} (adjacent node{{i+1}}-{{j+1}} node{{i+1}}-{{j}}) {% endif %}
        {%- if i > 0 -%} (adjacent node{{i+1}}-{{j+1}} node{{i}}-{{j+1}}) {% endif %}
        {%- if (i+2) < (data.size + 1) -%} (adjacent node{{i+1}}-{{j+1}} node{{i+2}}-{{j+1}}) {% endif %}
        {% endfor %}
        {% endfor -%}

        ; positions relations - CHANGE PER GRID SIZE
        {% for i in range(data.size) %}
        {%- for j in range(data.size) -%} (position node{{i+1}}-{{j+1}}) {% endfor %}
        {% endfor %}
    )

    (:goal (and
        ; head relations - CHANGE PER PROBLEM
        {% for colour, node in data.goal.heads.items() -%}
        (head node{{node}} {{colour}}) {% endfor %}

        ; not-empty relations - CHANGE PER GRID SIZE
        {% for i in range(data.size) %}
        {%- for j in range(data.size) -%} (not (empty node{{i+1}}-{{j+1}})) {% endfor %}
        {% endfor %}
    ))


)
