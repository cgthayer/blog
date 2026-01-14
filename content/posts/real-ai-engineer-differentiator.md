---
title: What Separates the Real AI SW Engineers
date: 2026-01-09T13:34:01-08:00
draft: true
tags: []
categories: []
---

**tldr**; evals or benchmarking for quality.

Those of us who write AI applications that use LLMs fall into two categories, usually based on whether you have run a production system, with real users, over time. That key differentiator is "evals", but not specifically traditional ML evals. It's really as simple as whether you have an automated way to test and score the ***quality*** of your systems.

A year ago, I was working on several projects, and one needed a much higher degree of quality and attention because it was medical. The project was 100% about trust. Not only did it need to be highly accurate, but it had many moving parts including over a dozen agents. My fellow developer did an amazing job of making it accurate, thorough, and consistent. There were a few key tricks to make this coordination work well, but what really impressed me was how important having some sort of benchmark is, for making a high quality system.

If you don't have measures and metrics, a myriad of problems come up at every phase of development:

**Problems with Developing**

When the team is first writing the application and trying to reach that crucial step of getting the minimum feature set functioning:

* **Prompt Churn**: You keep changing the prompt to "make it work" but with every prompt change you might improve the output for one input, but hurt other cases. This is a game of ***whack-a-mole*** where fixing one problem reverts progress on others.
* **Error Amplification**: In a prompt change, a shift early in the pipeline causes downstream agents to different inputs, and with each step errors grow. This is like a game of ***telephone***, where the output gets worse and less predictable as the chain gets longer.
* **Prompt Bloat**: In an attempt to handle different inputs the prompt keeps growing because your afraid to update the start of the prompt. You may even wind up with a prompt that contradicts itself if many people are contributing. Ultimately, you'll even cause the context window to grow too large and the LLM will be unable to pay attention to all of it when trying to get something done. This is like a ***windbag*** who starts talking and everyone eventually gets up and leaves as they ramble on.
  
**Problems with Beta Testing**

You finally get a working system in front of real users, and start getting real feedback.

* **Change Fear**: You want to fix something a user has called out, or handle a new case, but you're afraid to make a change (see prompt churn). The ***domino effect***.
* **Focus**: Typically you had a theory about what's valuable to your users, but putting in front of people causes a natural shift in that thinking, plus you learn about a lot of problems you hadn't considered. Like they say "The map is NOT the territory". Here you're wondering if you can safely update the prompt to handle the new use cases in one agent, or if you need to split the work up into two prompts or agents. You'll may do better not to try to ***"eat the elephant"***.
* **Timeliness**: Because the development process takes time, the context may shift as well. For example, you built based on web pages that got updated, or other data that is growing. Now you realize you need want to re-test with newer data but have to go through that manually. Maybe you even used a model that was trained half a year ago so you absolutely need to a web tool to get up-to-date news, or you need to switch to the latest greatest foundation model. Neither of which feels safe. You're product is in danger of being ***"past your sell-by-date"***.
* **Cost Control**: Now that you have real customers you're shocked at how much of your budget and much tokens are costing you. You wish you could decrease the context size of your prompts but you don't know if that's safe. Maybe you could use a cheaper or OSS model, but again you don't know if that's safe. This is the difference between having a profitable business and being out of business. Your new plane is ***outta-runway*** ---you probably move forward burning through investor money to prove your product-market-fit.
* **Tooling**: You likely have tool-calling (tool-use) and maybe MCPs but since you didn't develop these, you discover their short comings as you go. Now you realize your `WebFetchTool` only grabs the first 8k of a web site, etc. This is another issue you discover but have to table until your startup has income.

**Problems with Production**

You've ironed out a lot of issues by this stage and you're finally going GA with a full launch. Now it's hard to respond to folks individually and understand how all your users are doing.

* **Flying Blind**: Things go well and you grow like crazy. But with alerts and logs you only investigate the most severe issues. Things feel fragile, like the next update could accidentally trigger a surprising amount of churn. You find you're digging into your trace spans to figure out how little problems are causing error amplification.

Then **Context-Debt**: As real user data builds up, which is great, it creates more context to manage going into your prompts. It feels like tech debt where you have a nagging demon on your shoulder that you don't have time to banish. The data build up has lots of negative side effects, and it's time for some serious context engineering:

* **Latency Hit**: . In turn, this slows down answer latency and TTFT (time to first token), but your like a cooking frog. It's growing linearly with time, so you don't notice you're boiling, until your CEO realizes too late that it's caused a big customer to churn.
* **Context Costs**: The context window has a direct relationship to tokens and costs, which just keeps creeping up. Perhaps the worst part is it effects the best and most loyal customers the most. 
* **Context Quality Cliff**: For the same reason, this context build-up, the long context windows cause the LLM to loose track of what it's doing and emit really poor results. Now you have to scramble to implement a better context compression scheme and a real memory sub-system for your use-cases.

You want and need lots of things at this point. But let's just take one critical step first.

What you need is testing. And I call this Evals, to distinguish from unittests and end-to-end tests. But evals really come from ML and larger training sets, like the ones for classifiers. Instead, I mean something like benchmarks that produce a score, or a set of scores for both individual prompts (and agents) as well as multi-agent systems (workflows, pipelines, swarms, etc.). This might be a single prompt with a nice rubric, which we'll call an LLM-judge, or it could be a panel of agents that review and score different aspects, the LLM-jury.



Let me step back, and talk about some of your high-level options and terminology:

## Types of Test for AI Systems

(This is sidebar)

At a simple level, evals are how we test AI systems, but the term evals covers a lot of ground. In reality there are lots of types of tests mainly grounded in an ML background. Let me explain. First there's online vs offline, then there's human vs LLM-as-a-judge, so that gives us 4 flavors off the bat. Plus there's RAG which looks more like search bench-marking with it's accuracy, precision, and recall. On top of these there are a variety of standard testing approaches and styles.

![evals-overview.excalidraw|800](evals-overview.excalidraw.md)


Diagram: What you see here is Human vs Automated on the horizontal axis, which naturally separates between the manual human curate work, and the more involved automations where serious time and data need to be employed to get the best results.
Similarly, we have Offline vs Online where the offline is happening on a developers bench (laptop or staging) and online is live in real-time with users or close to it.

1. Human Offline: here a developer is kicking off a benchmark or test run of some kind. In traditional ML you may be use test-evals the same way you would if testing a model you've been training. You have golden, ground truth, expected results --both positive and negative feedback. If not binary, you may have many labels, like is this imgae "pizza" or "hotdog", so this is when the work is generally supervised.
2. Automated Offline: This is the next level, where you write a prompt to judge the output. You probably still do all the other things, but with the LLM-judge your trying to extend the human reviewers for leverage. This can also extend the inputs by generating synthetic random data and also judging that. Ideally you have occasional human supervision (like RLHF) but you're probably finding cases that go back into your golden data set.
3. Human Online: Here is where you have live feedback. When you get to this stage you have probably grown to the point where the scale has overwhelmed the humans. You've placed buttons on the UI for thumbs up / thumbs down feedback, maybe even provided a way for users to write about their reasoning, expectations, and intentions. This is the parallel to filing an AI "bug report" for review --maybe even automated flagging.
4. Automated Online: The is the automated equivalent. You may have a judge that looks are a sampling of conversations to detect unusual cases for further review. At this point, you have logging and traces (spans). Information, like high latency or cost automatically flag cases for review, without the user calling out poor performance.

This covers a lot of ground, but I need to mention one more:

Conversations: these are hard to test and can follow many paths through an agent and tool calls. The best method I'm aware of is what I call Bot-Tests, and I've heard call **LLM-as-a-user**. Here you set up an agent to converse as if it's a user with enough background on how you'd like the conversation to evolve. A great example is in the medical context. Imagine you setup an agent to act as a patient with a specific illness, but to pretend it doesn't know what the illness is, then gradually exhibit more and more symptoms.

## Code

A prompt
A test - generic good bad
llm-judge - a prompt, then a rubric
llm-jury - a set of perspectives


test2