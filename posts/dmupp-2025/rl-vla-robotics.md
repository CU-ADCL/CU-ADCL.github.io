---
title: "Bridging Language and Action: How Vision-Language-Action Models and Reinforcement Learning Enable Intelligent Robotic Decision Making"
layout: single
permalink: /posts/dmupp-2025/rl-vla-robotics/
class: resources
toc: true
toc_icon: "link"
toc_sticky: true
author: Lorin Achey
author_email: lorin.achey@colorado.edu
mathjax: true
---

## 1. Introduction

The intersection of natural language understanding and robotic control is an exciting, active area of research in robotics. Advances in Large Language Models (LLMs) and Vision-Language Models (VLMs) paved the way for Vision-Language-Action (VLA) models which are systems capable of translating high-level human instructions into executable robot behaviors. At the same time, Reinforcement Learning (RL) remains the dominant framework for solving sequential decision-making problems in robotics. The convergence of these two approaches offers a promising path toward building general-purpose robotic systems that can understand human intent, reason about their environment, and adapt to novel situations.

When I first learned about VLAs, I imagined them as a substitute for traditional Reinforcement Learning. Consider a simple navigation task: moving a robot through a grid world to reach a goal state. In a classical RL setup, the robot would explore through trial and error, eventually learning an optimal policy from reward feedback. In contrast, I pictured a VLA-based system where I could simply instruct the robot, "Go to the green circle," and it would infer the necessary sequence of actions from visual input. This framing makes RL and VLAs seem fundamentally distinct.

However, recent research suggests otherwise. RL and VLAs are being used in combination, from the use of RL during pre-training and supervised fine-tuning to hierarchical control stacks in autonomous navigation. So this blog post that began as a comparison between two seemingly distinct paradigms became an exploration of their interconnected use cases. In this post, we'll examine how RL and VLA models complement each other in addressing core challenges in robotics. We'll introduce some theoretical foundations and then discuss practical integration strategies that enable robots to combine semantic understanding with low-level adaptive control.

## 2. Foundations

Before diving into how Reinforcement Learning (RL) and Vision-Language-Action (VLA) models intersect, let's briefly review their conceptual foundations.

### 2.1 Reinforcement Learning

Reinforcement Learning is a framework for sequential decision-making under uncertainty. We'll consider the fully observable case here, but know that there's also a partial observability case where parts of the environment are hidden or noisy.

An RL agent interacts with an environment commonly modeled an Markov Decision Process (MDP), formalized as a tuple $\mathcal{M} = (\mathcal{S}, \mathcal{A}, P, R, \gamma)$ where:

- $\mathcal{S}$ is the state space representing possible robot and environment configurations
- $\mathcal{A}$ is the action space containing available robot actions
- $P: \mathcal{S} \times \mathcal{A} \times \mathcal{S} \to [0,1]$ is the transition probability function
- $R: \mathcal{S} \times \mathcal{A} \to \mathbb{R}$ is the reward function
- $\gamma \in [0,1)$ is the discount factor

The Markov property ensures that the future state depends only on the current state and action:

$$P(s_{t+1} | s_t, a_t, s_{t-1}, a_{t-1}, \ldots) = P(s_{t+1} | s_t, a_t)$$

At each timestep $t$, the agent observes a state $s_t$, takes an action $a_t$, receives a reward $r_t$, and transitions to a new state $s_{t+1}$. The goal is to learn a policy $\pi(a\|s)$ that maximizes the expected cumulative discounted reward:

$$J(\pi) = \mathbb{E}_{\tau \sim \pi} \left[ \sum_{t=0}^{\infty} \gamma^t r_t \right]$$

where $\tau = (s_0, a_0, s_1, a_1, \ldots)$ denotes a trajectory sampled by following policy $\pi$.

RL algorithms approach this optimization problem in different ways. **Value-based methods** learn to estimate how good it is to be in a state or take an action. The state-value function $V^\pi(s)$ represents the expected return from state $s$ under policy $\pi$:

$$V^\pi(s) = \mathbb{E}_{\tau \sim \pi} \left[ \sum_{k=0}^{\infty} \gamma^k r_{t+k} \mid s_t = s \right]$$

Similarly, the state-action value function (Q-function) quantifies the expected return from taking action $a$ in state $s$:

$$Q^\pi(s, a) = \mathbb{E}_{\tau \sim \pi} \left[ \sum_{k=0}^{\infty} \gamma^k r_{t+k} \mid s_t = s, a_t = a \right]$$

**Policy gradient methods** directly optimize the policy parameters $\theta$ to maximize $J(\pi_\theta)$ by computing gradients:

$$\nabla_\theta J(\pi_\theta) = \mathbb{E}_{\tau \sim \pi_\theta} \left[ \sum_{t=0}^{T} \nabla_\theta \log \pi_\theta(a_t|s_t) \cdot A^\pi(s_t, a_t) \right]$$

where $A^\pi(s, a) = Q^\pi(s, a) - V^\pi(s)$ is the advantage function, measuring how much better action $a$ is compared to the average action in state $s$.

Modern deep RL algorithms leverage neural networks to approximate these functions in high-dimensional spaces. **Proximal Policy Optimization (PPO)** [2] is an on-policy algorithm that uses neural networks to represent both the policy $\pi_\theta(a\|s)$ and value function $V_\phi(s)$, updating them through clipped policy gradients to ensure stable learning. **Soft Actor-Critic (SAC)** [1] is an off-policy actor-critic method that simultaneously learns a policy $\pi_\theta$ and Q-function $Q_\phi$ while maximizing both expected return and entropy. **Group Relative Policy Optimization (GRPO)** [3] is a policy gradient method that leverages group-based relative comparisons to improve learning efficiency and has been used for fine-tuning large pretrained models. These are just a few examples of RL algorithms. There are many more!

Many of these RL algorithms have been successfully applied to robotic control because they can learn directly from high-dimensional inputs (like images) and handle continuous action spaces. However, RL can still suffer from sample inefficiency, reward engineering challenges, and limited generalization to novel tasks or new domains. It's possible that VLA models may help address these issues.

### 2.2 Vision-Language-Action Models

Vision-Language-Action (VLA) models emerge from the foundation model paradigm. These systems combine large-scale pretraining on multimodal datasets (images, text, and sometimes video or actions) to learn joint representations that connect visual perception, linguistic understanding, and physical interaction. These models leverage internet-scale data leading to pretrained models that have exposure to much more diverse data than a typical robotics dataset.

* **Vision encoders** (e.g., ViTs, CNNs) map images or visual observations into latent embeddings.
* **Language encoders/decoders** (e.g., Transformers, LLMs) process textual inputs or instructions.
* **Action modules** map internal representations into motor commands, joint torques, or discrete control primitives.

In a VLA, these components are often connected through a shared embedding space or a transformer-based architecture that fuses multimodal information. This enables the system to interpret instructions such as *"Pick up the red cube and place it on the blue block"* and produce a coherent sequence of actions. There are many different action token representations, but for the sake of this post just envision directly outputting robotics controls. For an example, see Figure 1 which shows how image and text are input into the VLA which then outputs a vector of robot controls for a gripper.

<div align="center">
  <img src="https://raw.githubusercontent.com/lorinachey/AI-ML-Practice/main/Vision-Language/images/open-vla-diagram.png" width="70%" alt="OpenVLA Architecture Diagram">
  <p><em>Figure 1: OpenVLA architecture showing the integration of vision encoders, language models, and action prediction modules. Diagram from Liu et al. [11], representing the OpenVLA model [12].</em></p>
</div>


### 2.3 Conceptual Contrast

| Aspect              | Reinforcement Learning                         | Vision-Language(-Action) Models                                |
| :------------------ | :--------------------------------------------- | :------------------------------------------------------------- |
| **Core Objective**  | Maximize cumulative reward via interaction     | Learn multimodal representations and semantic grounding        |
| **Learning Signal** | Scalar rewards from environment                | Supervised or self-supervised cross-modal alignment            |
| **Data Source**     | Experience (simulated or real)                 | Large curated datasets (image–text–action triples)             |
| **Strengths**       | Adaptive control, exploration, online learning | Generalization, compositional reasoning, instruction following |
| **Limitations**     | Sample inefficiency, narrow task focus         | Lack of grounding without interaction, weak low-level control  |

### 2.4 Toward Integration

While these approaches originated separately, current research explores how to combine them for enhancing robot capabilities. RL provides a mechanism for adaptive control and feedback-driven learning, while VLAs supply semantic priors and contextual understanding. It's hypothesized that integrating the two will enable robots to act optimally and also understand what they are doing and why.

## 3. Where RL Meets VLA

The combination of Reinforcement Learning with Vision-Language-Action models is an active area of research and several promising strategies have emerged. In this section, we'll explore two main approaches: fine-tuning VLAs with RL and hierarchical architectures that combine both.

### 3.1 RL Fine-Tuning of VLA Models

VLA models have shown promise generalizing to new situations, but they can fall short when tasks demand high precision think contact-rich manipulation or tasks where exact positioning matters like low-level joint control. This is where RL fine-tuning comes in, allowing us to directly optimize the VLA policy using task-specific rewards.

Several recent papers have shown different ways to fine-tune VLAs with RL:

**VLA-R1 [4]** integrates Reinforcement Learning from Verifiable Rewards (RLVR) with Group Relative Policy Optimization (GRPO) in an effort to provide VLAs with chain-of-thought style reasoning capabilities seen in recent LLMs. This approach helps VLA models better reason about object affordances and generate action sequences that are physically plausible not just semantically correct.

**iRe-VLA [6]** tackles one of the practical challenges: direct RL fine-tuning can be computationally expensive and unstable. Their solution is an iterative framework that alternates between RL updates and supervised learning, in an effort to get the benefits of both approaches.

The main challenge here is a balancing performance improvements on specific tasks without losing the broad generalization that makes VLAs useful in the first place. Too much fine-tuning and the model risks catastrophic forgetting. Not enough fine-tuning and the model will be unable to perform well on the specified robotics specific tasks.

### 3.2 Hierarchical Architectures

Another strategy uses hierarchical architectures where VLA models and RL work at different levels of abstraction.

One approach is to separate high-level planning and low-level control:

- **High-level (VLA)**: Interprets language instructions and outputs subgoals or high-level action choices
- **Low-level (RL)**: Executes those high-level commands and handles the nitty-gritty details of motor/actuator/joint control

This division of labor has a practical advantage: the VLA can run at a slower rate while the RL controller runs fast. This matters because current VLAs are still slower than traditional low-level controllers. You don't want your robot waiting around for the VLA because it could cause instability in the controls.

**NaVILA [8]** is a great example of this approach in action (pun intended). The VLA gets fine-tuned to output "mid-level actions" (e.g. move forward 75 centimeters) which then feed into a PPO-trained RL policy. The RL policy takes those mid-level commands and figures out the specific joint movements needed to execute them. The researchers demonstrated this on real legged robots navigating different environments based on language commands. See the diagram below that shows the NaVILA system [8].

<div align="center">
  <img src="https://raw.githubusercontent.com/lorinachey/AI-ML-Practice/main/Vision-Language/images/navila-figure-2.png" width="70%" alt="NaVILA High-Level Diagram">
  <p><em>Figure 2: NaVILA hierarchical architecture. The VLA generates mid-level actions that are executed by a low-level RL policy trained with PPO. From Cheng et al. [8].</em></p>
</div>


**IRL-VLA [9]** applies a similar hierarchical idea to autonomous driving, using a three-stage approach:
1. Pretrain a VLA policy through imitation learning
2. Build a reward world model using inverse RL
3. Use that reward model to guide further RL training (with PPO)

The innovation proposed in this paper is that the reward model lets you train VLA agents with reinforcement learning without having to rely on a simulator.

## 4. Applications and Future Directions

The integration of VLA models and RL has enabled capabilities in several robotics domains (i.e. navigation, manipulation). VLA models can give robots the language and perception to understand our goals, while RL can give them the experience and feedback to achieve those goals effectively. As these two approaches continue to merge, we move closer to robots that can learn new tasks from natural instructions and improve through experience, just like humans do.

**Questions to ponder (potential future research directions)**:

1. Can we use VLAs to design methods that let RL fine-tune robot behavior with fewer real-world trials and less data?

2. Can a robot trained in simulation use the semantic understanding from a VLA to adapt more smoothly to the real world?

3. What would it take for a robot to know when it's unsure about its perception or decision, and explore safely as a result? Can a combination of VLAs and RL lead to verifiably safer systems?

4. Could natural language become a way for people to give feedback and guide a robot's learning process in real time? How would this combination of natural language through human-feedback differ from a typical Reinforcement Learning through Human Feedback paradigm (RLHF)?


## 5. Conclusion

Integrating Vision-Language-Action models and Reinforcement Learning is a promising direction for improving robot capabilities. VLA models provide semantic understanding, broad generalization, and efficient learning from diverse offline data. RL contributes adaptive optimization, fine grained control, and the ability to discover novel behaviors through environmental interaction.

By carefully integrating these approaches whether through direct RL fine-tuning or hierarchical architectures, we can build robotic systems that combine the semantic richness of large-scale pre-training with RL's ability to produce precise low-level control. As these methods mature and scale, we move closer to more capable robots that can understand natural language instructions, reason about their environment through visual perception, and continuously improve their capabilities through experience.


## 6. References

*NOTE: Whenever possible, this post references peer-reviewed literature from the robotics domain. However, some of the most recent works are still in review and thus have not been through the peer-review process yet. These cited works are preprint editions and their Arxiv links are provided.*

1. Haarnoja, T., Zhou, A., Abbeel, P., & Levine, S. (2018). [Soft Actor-Critic: Off-Policy Maximum Entropy Deep Reinforcement Learning with a Stochastic Actor.](https://arxiv.org/abs/1801.01290) *ICML 2018*.

2. Schulman, J., Wolski, F., Dhariwal, P., Radford, A., & Klimov, O. (2017). [Proximal Policy Optimization Algorithms.](https://arxiv.org/abs/1707.06347) *arXiv preprint*.

3. Shao, Z., Wang, P., Zhu, Q., Xu, R., Song, J., Bi, X., Zhang, H., Zhang, M., Li, Y.K., Wu, Y., & Guo, D. (2024). [DeepSeekMath: Pushing the Limits of Mathematical Reasoning in Open Language Models.](https://arxiv.org/abs/2402.03300) *arXiv preprint*.

4. Ye, A., Zhang, Z., Wang, B., et al. (2025). [VLA-R1: Enhancing Reasoning in Vision-Language-Action Models.](https://arxiv.org/abs/2510.01623) *arXiv preprint*.

5. Song, Z., Ouyang, G., Li, M., et al. (2025). [ManipLVM-R1: Reinforcement Learning for Reasoning in Embodied Manipulation with Large Vision-Language Models.](https://arxiv.org/abs/2505.16517) *arXiv preprint*.

6. Chen, Y., et al. (2024). [Improving Vision-Language-Action Model with Online Reinforcement Learning (iRe-VLA).](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=11127299) *ICRA 2025*.

7. Wang, Y., Sun, Z., Zhang, J., et al. (2024). [RL-VLM-F: Reinforcement Learning from Vision Language Foundation Model Feedback.](https://proceedings.mlr.press/v235/wang24bn.html) *ICML 2024*.

8. Cheng, A., et al. (2025). [NaVILA: Legged Robot Vision-Language-Action Model for Navigation.](https://www.roboticsproceedings.org/rss21/p018.pdf) *Robotics: Science and Systems 2025*.

9. Jiang, A., Gao, Y., Wang, Y., et al. (2025). [IRL-VLA: Training a Vision-Language-Action Policy via Reward World Model.](https://arxiv.org/abs/2508.06571) *arXiv preprint*.

11. Liu, J., Gao, F., Wei, B., Chen, X., Liao, Q., Wu, Y., Yu, C., & Wang, Y. (2025). [What Can RL Bring to VLA Generalization? An Empirical Study.](https://arxiv.org/abs/2505.19789) *arXiv preprint*.

12. Kim, M. J., Pertsch, K., Karamcheti, S., Xiao, T., Balakrishna, A., Nair, S., Rafailov, R., Foster, E., Lam, G., Sanketi, P., et al. (2024). [OpenVLA: An Open-Source Vision-Language-Action Model.](https://arxiv.org/abs/2406.09246) *arXiv preprint*.
