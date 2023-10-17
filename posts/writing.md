---
title: Writing Tips
layout: single 
permalink: /posts/writing/
class: resources
toc: true
toc_icon: "link"
toc_sticky: true
---

## Passive voice and using "we"

In general, active voice (e.g. "He moved the box.") is a more direct and easy-to-understand way of writing compared to passive voice (e.g. "The box was moved."). However, many scientists and engineers use passive voice in their papers. A large portion of scientific papers is devoted to describing what experiments the scientists conducted. Often, the most natural subject of sentences describing these experiments is "we", referring to the scientists who conducted the experiment and are writing the paper. However, scientists usually want to put the focus on the experiments rather than the experimenters. Thus, many scientists and engineers have adopted a rule that does not allow the use of "we" or "our" in technical writing. Focusing on the science is a good impulse, but unfortunately the easiest way to avoid "we" is to resort to using the passive voice, which makes papers more difficult to understand.

There is an additional confounding twist in this story: Mathematicians often use "we" in their papers, however they are typically referring to a different group of people than scientists and engineers. Usually, mathematicians seek to lead a reader through a line of reasoning, for example "Since 51 is a product of 3 and 17, we can conclude that it is not prime." In this case, "we" refers to the author and the reader rather than the people who conducted an experiment. When used in this way "we" has been much more commonly accepted in mathematical writing than the "we" that refers to the authors in scientific writing.

So, we are left with the question: should we use "we" in sentences describing the experiments that we carry out?
My guidance is the following: It is acceptable to use "we" to avoid passive voice. However, whenever practical, writing should focus on the scientific concepts rather than the people writing the paper or doing the work. Here is an example:

- Discouraged (passive): "A hyperparameter search was used to determine that 0.001 is the best learning rate."
- Discouraged ("We"): "We conducted a hyperparameter search to find that 0.001 is the best learning rate."
- Preferred: "A hyperparameter search revealed that the best learning rate is 0.001."

"We" generally does not need to be used in sections such as the background or problem formulation, for example

- Discouraged: "We formulated the following POMDP model of the problem:"
- Preferred: "The following POMDP models the important features of the problem:"
