
PM
- What did I _learn_ today? TIL ...
- What was _interesting_?
- What might people _not know_?
- What is _useful_ to others?
- What was fun today?

# What Separates the Real AI SW Engineers

tldr; evals or benchmarking for quality.

Those of us who write AI applications that use LLMs fall into two categories, usually based on whether you have run a production system with real users over time. That key differentiator is "evals", but not specifically traditional ML evals. It's really as simple as whether you have an automated way to test and score the quality of your systems.

Quick Story: 
 

Some folks may think that using an editor with AI makes them 
Until you've built test to prove the quality of your AI system, prompts, agents. 

## Types of Test for AI Systems

At a simple level, evals are how we test AI systems, but the term evals covers a lot of ground. In reality there are lots of types of tests mainly grounded in an ML background. Let me explain. First there's online vs offline, then there's human vs LLM-as-a-judge, so that gives us 4 flavors off the bat. Plus there's RAG which looks more like search bench-marking with it's accuracy, precision, and recall. On top of these there are a variety of standard testing approaches and styles.

![evals-overview.excalidraw|800](evals-overview.excalidraw.md)