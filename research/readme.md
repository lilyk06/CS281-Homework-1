# Deliberate Gap Learning (DGL): Research Overview and Follow-Up Study Direction

## Purpose of This Document

This document describes **Deliberate Gap Learning (DGL)** for a
computing-education research audience.

It has three goals:

1.  Summarize the original DGL model and baseline study.
2.  Document how the next course deployment modifies the model in
    response to the baseline findings.
3.  Identify the questions and measures that a follow-up study could use
    to evaluate whether those changes improve the learning experience
    while preserving the behaviors DGL was designed to encourage.

The revised implementation described here should be viewed as an
evolution of the original framework rather than a rejection of it.

The original study established a useful baseline. The follow-up
deployment uses those findings to make the deliberate gap more visible,
improve the transition from software to hardware, reduce repetitive
assessment burden, and measure more directly whether the mechanism
intended to drive inquiry is actually working.

------------------------------------------------------------------------

# 1. The Problem DGL Is Trying to Address

Large language models create a structural problem for conventional
homework.

If an assignment primarily asks students to produce answers,
explanations, code, or other deliverables that an AI system can generate
competently, then the submitted artifact no longer provides strong
evidence that the student performed the intended intellectual work.

One response is to prohibit or restrict AI.

DGL takes the opposite approach.

Its premise is that the educational opportunity is not to prevent
students from using a tool that will increasingly be part of
professional technical practice, but to redesign homework so that
**productive AI use and the intended learning process become aligned**.

The central idea is:

> **AI should function as an inquiry partner rather than an answer
> generator.**

The assignment therefore needs to reward behaviors such as:

-   asking useful follow-up questions,
-   refining incomplete explanations,
-   recognizing oversimplification,
-   verifying technical claims,
-   synthesizing across multiple exchanges,
-   and connecting new understanding to prior technical work.

In this model, the process of investigation becomes an important
learning artifact.

------------------------------------------------------------------------

# 2. Original Deliberate Gap Learning Model

The original DGL framework was introduced and deployed across seven
homework assignments in an undergraduate systems architecture course.

Its core design principle was intentionally unconventional:

> **Homework should investigate material adjacent to, but intentionally
> not covered in, lecture.**

Lecture established the foundational vocabulary and conceptual
framework.

Labs developed procedural competence through code, assembly, circuits,
and other hands-on work.

Homework then extended that foundation into a deliberately uncovered
area.

The intended instructional relationship was therefore:

``` text
Lecture
    |
    v
Foundational concepts

Lab
    |
    v
Hands-on experience

Homework
    |
    v
Deliberate gap
    |
    v
AI-supported investigation
```

The gap was not intended to be arbitrary.

Each assignment began from something the student had recently built or
used in a lab and then asked the student to investigate a mechanism,
tradeoff, or implication that was adjacent to that experience.

This adjacency is central to DGL.

The student should know enough to recognize the question and reason
about the answer, but not enough to simply retrieve the answer from
lecture notes.

------------------------------------------------------------------------

# 3. Original Assignment Structure

The baseline DGL assignments used a fixed four-part, 100-point
structure.

## Investigation Log --- 30 points

Students documented approximately 6--10 AI prompts and briefly explained
the reasoning behind their follow-up questions.

The goal was to make iterative inquiry visible.

A single prompt followed by acceptance of the first answer represented
weak engagement.

Increasing specificity, clarification, challenge, and verification
represented stronger engagement.

## Synthesis --- 30 points

Students explained what they had learned in their own words without
referring back to the AI transcript.

The design assumption was that genuine understanding should leave the
student able to reconstruct the explanation rather than merely reproduce
AI output.

## Critical Check --- 20 points

Students identified at least one AI claim that appeared unclear,
oversimplified, questionable, or potentially incorrect and documented
how they investigated it further.

The AI did not have to be wrong.

The purpose was to make **epistemic scrutiny** an explicit graded
behavior.

## Connect It Back --- 20 points

Students connected the investigation to the lab work that preceded the
assignment.

This closed the loop between:

``` text
something the student built
        |
        v
something the student investigated
        |
        v
a revised conceptual model
```

The original DGL model therefore graded the investigative process rather
than only the correctness of a final answer.

------------------------------------------------------------------------

# 4. Original Research Questions

The baseline study examined three broad questions.

## RQ1 --- Reported conceptual learning

What learning gains do students report across DGL assignments?

Students retrospectively rated their understanding before and after each
investigation, and normalized gain was used descriptively to
characterize change.

## RQ2 --- Quality of AI engagement

When assignment design requires students to document their inquiry, do
they engage with AI iteratively and critically, or do they still default
to shallow prompt-and-accept behavior?

The survey distinguished between modes such as:

-   single-exchange use,
-   back-and-forth follow-up,
-   active challenge/refinement,
-   and AI use combined with external verification.

## RQ3 --- Student perception of the format

How do students perceive DGL relative to conventional homework in terms
of:

-   learning value,
-   cognitive engagement,
-   assignment clarity,
-   and overall preference?

The baseline was intentionally a characterization study rather than a
controlled causal evaluation.

------------------------------------------------------------------------

# 5. What the Baseline Study Found

The original seven-assignment deployment produced several encouraging
findings.

Across the deployment, students reported medium-to-high conceptual
gains, with a pooled normalized gain of approximately **0.46**.

Reported AI engagement was also substantially deeper than the low-effort
interaction DGL was designed to discourage. The paper reports
approximately **92.2% average deep engagement** across assignments,
while reported temptation to copy AI output remained relatively stable.

The Critical Check also performed better than anticipated. Requiring
students to question or verify AI output was not consistently
experienced as the least valuable part of the assignment.

These findings support the basic DGL premise:

> Assignment design can make iterative, critical AI engagement a normal
> part of technical homework rather than treating AI solely as an
> integrity threat.

However, the baseline also revealed important limitations.

------------------------------------------------------------------------

# 6. The Most Important Baseline Findings for the Redesign

## 6.1 The deliberate gap must be genuinely adjacent

One of the strongest course-level patterns occurred when the curriculum
transitioned from ISA/software-oriented material into digital hardware.

Reported gains weakened in the second half of the sequence.

The original paper identifies this as an important design constraint:

> DGL appears strongest when the deliberate gap is adjacent to a
> foundation students already understand.

If both the underlying material and the deliberate gap are
simultaneously unfamiliar, students may spend their effort constructing
the prerequisite model rather than productively extending it.

This is particularly important in computer architecture courses for CS
students, where the transition from sequential software reasoning to
physical hardware reasoning can itself be a substantial conceptual
discontinuity.

## 6.2 Seven structurally identical assignments created fatigue

Students continued to report meaningful learning and deep AI engagement,
but satisfaction with the format declined across the term.

By the second half of the course, students were increasingly likely to
describe the experience as task completion rather than genuine learning.

The baseline paper therefore recommends attention to:

-   deployment volume,
-   format variety,
-   cognitive load,
-   and expectation-setting.

This is an important distinction.

The mechanism appeared to continue producing productive behaviors even
as the student experience became less positive.

A follow-up design should therefore avoid discarding the productive
mechanism while addressing the experience around it.

## 6.3 AI-supported inquiry is effortful

The original deployment began with an expectation that CS students might
strongly welcome required AI use because AI fluency has obvious
professional relevance.

Student reception was more moderate.

One interpretation raised by the paper is that students distinguish
between:

``` text
AI for productivity
```

and:

``` text
AI for learning
```

DGL deliberately requires the second.

Using AI to construct understanding, challenge claims, and verify
evidence can be more cognitively demanding than using AI to generate a
conventional homework answer.

The follow-up deployment therefore makes the purpose of the model more
explicit to students from the beginning.

## 6.4 The baseline depended heavily on self-report

The original study used anonymous retrospective survey measures.

This provided a low-burden baseline, but it also created several
limitations:

-   self-reported learning is not demonstrated mastery,
-   self-reported engagement may be affected by social desirability,
-   conceptual gain, engagement, and perceived value came from the same
    instrument,
-   approximately 30% of students were not represented in HW2--HW7
    survey data,
-   and there was no comparison condition.

The original paper identifies cross-validation against submitted
investigation logs as an especially important next step.

------------------------------------------------------------------------

# 7. DGLv2: The Revised Model

The revised deployment preserves the central DGL premise but changes how
the deliberate gap is created and how students move through it.

The most visible change is the introduction of an explicit **5C model**:

``` text
Connect
   |
   v
Confront
   |
   v
Concept
   |
   v
Construct
   |
   v
Confirm
```

This structure makes the cognitive progression of the assignment
explicit.

------------------------------------------------------------------------

# 8. Connect

Each assignment begins from a concept, program, circuit, or experience
students already possess.

This preserves the adjacency principle from the original DGL model but
makes it more explicit.

Examples include:

-   RISC-V load/store behavior,
-   array traversal,
-   polling loops,
-   ISA extensions,
-   a full-adder circuit,
-   an ALU,
-   and sequential instruction execution.

The purpose is to establish:

> **Here is the model you already have.**

This is particularly important before the hardware-oriented assignments,
where the baseline study suggested the conceptual transition had become
too large.

------------------------------------------------------------------------

# 9. Confront

The largest change in DGLv2 is the **Confront** stage.

Rather than beginning primarily with a written investigation prompt,
most assignments now use a short instructor demonstration designed to
expose a contradiction between the student's current model and observed
behavior.

Examples include:

-   the same computation requiring different instruction sequences on
    x86-64 and RISC-V,
-   identical array operations producing different runtimes because only
    memory access order changed,
-   polling and interrupt-driven programs producing the same visible
    result with radically different CPU activity,
-   hardware floating point providing major benefits while still being
    optional,
-   a gate-level circuit producing stale or incorrect values when
    observed before propagation completes,
-   sequential RISC-V instructions overlapping on multiple execution
    resources while a dependent instruction must wait,
-   and CPU/GPU matrix multiplication changing relative behavior as the
    amount of parallel work grows.

The intended mechanism is:

``` text
Student prediction
       |
       v
Observed contradiction
       |
       v
"Why did that happen?"
       |
       v
Motivated investigation
```

The demonstration is not intended to provide the answer.

It is intended to make the deliberate gap **visible**.

This is a significant refinement of the baseline DGL design.

The original framework intentionally left a gap in coverage.

DGLv2 attempts to make students *experience* that gap before asking them
to investigate it.

------------------------------------------------------------------------

# 10. Concept

After the contradiction is visible, the assignment provides a limited
conceptual scaffold.

This section deliberately stops short of resolving the entire question.

Its role is to provide enough vocabulary and structure that the student
can conduct a productive AI investigation without having to discover the
foundational model from scratch.

This directly responds to the baseline finding that DGL becomes weaker
when the gap is not sufficiently adjacent to what the student already
understands.

Concept therefore acts as a bridge:

``` text
current model
     |
     v
observed contradiction
     |
     v
minimum scaffold
     |
     v
productive gap
```

------------------------------------------------------------------------

# 11. Construct

Construct preserves the inquiry-centered core of the original DGL model.

Students use an AI assistant to investigate the unresolved architectural
question.

However, the revised assignments provide a more scaffolded sequence of
starting questions rather than primarily evaluating a fixed-size prompt
log.

Students are explicitly encouraged to:

-   follow explanations where their understanding requires it,
-   ask clarifying questions,
-   challenge oversimplifications,
-   connect ideas across the course,
-   investigate real processors and systems,
-   and verify technical claims.

The AI remains the **inquiry partner**, not the source of a deliverable.

------------------------------------------------------------------------

# 12. Confirm

The revised model replaces the original large synthesis-oriented rubric
with a more conventional-looking assessment layer that still measures
the DGL behaviors.

Each assignment contains:

-   multiple-choice conceptual checks,
-   a corrected-model explanation,
-   a real-world or quantitative investigation,
-   a required AI critical check,
-   identification of the student's most useful follow-up question,
-   and explicit connections back to the demonstration or course
    concepts.

The complete AI conversation is also submitted as evidence of the
investigation.

Each assignment contains **100 academic points**, with **5 additional
completion-only feedback points**.

The revised Confirm stage is intended to reduce the feeling of
repeatedly producing the same four large artifacts while retaining the
central behaviors of DGL.

------------------------------------------------------------------------

# 13. "Catch the AI" Remains a Core Mechanism

The original Critical Check has been retained in a more student-facing
form called **Catch the AI**.

Students identify one AI claim that deserves verification.

Importantly:

> The AI does not need to be wrong.

The desired behavior is recognizing that a technical statement deserves
evidence.

Students document:

-   what the AI claimed,
-   why the claim deserved scrutiny,
-   what they did to check it,
-   and what they concluded.

This preserves one of the strongest elements of the original framework:
skepticism is not merely recommended; it is required and graded.

------------------------------------------------------------------------

# 14. The Revised Seven-Assignment Arc

The follow-up implementation also changes the conceptual sequence.

The course is designed to progressively move a CS student from the
software abstraction toward the hardware beneath it.

  -----------------------------------------------------------------------
  HW                                  Revised deliberate gap
  ----------------------------------- -----------------------------------
  **HW1 --- Same Program, Different   If simpler instructions make
  Instructions**                      simpler processors, why can a
                                      richer ISA express the same
                                      computation with fewer
                                      architectural instructions?

  **HW2 --- Same Operations,          If two programs perform the same
  Different Speed**                   operations the same number of
                                      times, why can changing only memory
                                      access order dramatically change
                                      runtime?

  **HW3 --- Same Event, Different     If polling and interrupts produce
  Power**                             the same visible result, why can
                                      the underlying CPU activity and
                                      energy cost be radically different?

  **HW4 --- The Extension You Don't   If dedicated hardware makes an
  Get for Free**                      operation much faster, why would a
                                      processor designer deliberately
                                      omit it?

  **HW5 --- Your Code Runs One Line   Software encourages a sequential,
  at a Time. Your Circuit Doesn't.**  instantaneous model of computation;
                                      physical circuits are concurrent
                                      and require time to settle.

  **HW6 --- Your Program Is           If the architectural program is
  Sequential. Your Processor Is       sequential, how can multiple
  Not.**                              instructions execute concurrently,
                                      and why do dependencies limit that
                                      parallelism?

  **HW7 --- One Architecture Doesn't  If modern CPUs are extremely
  Fit Every Problem**                 capable, why do highly parallel and
                                      AI workloads motivate GPUs and
                                      increasingly specialized
                                      accelerators?
  -----------------------------------------------------------------------

The HW5--HW7 sequence is intentionally designed to address the
software-to-hardware discontinuity observed in the baseline study.

Rather than moving directly into increasingly unfamiliar hardware
topics, the sequence becomes:

``` text
HW5
Software's sequential model breaks at the physical circuit

        |
        v

HW6
The CPU exploits physical parallelism beneath sequential software

        |
        v

HW7
The CPU itself is revealed as only one architectural solution
```

The intended result is a more continuous conceptual bridge.

------------------------------------------------------------------------

# 15. Revised Student Orientation

DGLv2 also explicitly explains the model to students before the first
assignment.

Students are told:

-   why AI use is required,
-   why the assignments may be more cognitively demanding than
    AI-assisted answer generation,
-   what the 5C structure means,
-   that the instructor demonstration creates the question rather than
    supplying the answer,
-   what productive AI investigation looks like,
-   that confusion is an expected part of the process,
-   and that AI output should not automatically be treated as evidence.

This directly responds to the baseline paper's recommendation to address
the **effort-expectations gap** before students encounter it.

------------------------------------------------------------------------

# 16. Revised Measurement Strategy

The follow-up implementation embeds a short completion-only feedback
instrument in each assignment.

The recurring measures are designed around specific mechanisms in DGLv2
rather than only general satisfaction.

## B1 / P1 --- Retrospective conceptual understanding

Each homework asks students to characterize their understanding before
and after the assignment using topic-specific five-point anchors.

This retains a version of the baseline retrospective pre/post strategy
while making each item correspond to the assignment's central conceptual
model.

The goal is to examine whether the revised sequence continues to produce
reported conceptual change.

## INV --- What drove the investigation?

Students identify what primarily motivated their AI investigation.

Options distinguish among:

-   efficient task completion,
-   answering required questions,
-   resolving the contradiction created by the assignment/demo,
-   and understanding deeply enough to transfer the idea beyond the
    assignment.

This measure is intended to help distinguish **compliance-driven
engagement** from **question-driven inquiry**.

## DEMO --- Did the Confront mechanism create curiosity?

A new measure asks how strongly the demonstration made the student want
to understand the observed contradiction.

This directly measures a mechanism that the baseline study did not
isolate:

> **Did the deliberate gap actually generate a question the student
> wanted to resolve?**

This item is especially important because the revised model invests
substantially more instructional effort in the Confront stage.

## FAV --- What contributed most to understanding?

Students identify the assignment component that helped them most.

Possible responses include the demonstration, Concept scaffold, AI
investigation, verification activity, real-world investigation, and
Confirm questions.

This allows comparison between the mechanism that creates curiosity and
the component students ultimately perceive as most useful for learning.

## SCA --- Should the format continue?

Students indicate whether the format should:

-   continue as is,
-   be adjusted,
-   or return to a traditional homework model.

This preserves a direct measure of format acceptance while allowing
optional qualitative feedback.

## AI Investigation Skills --- beginning, midpoint, end

Rather than repeating the same AI-skills battery on all seven
assignments, the revised deployment uses it at:

-   **HW1**
-   **HW4**
-   **HW7**

The five items measure students' perceived ability to:

1.  decide what question to ask next,
2.  recognize when an AI claim needs further investigation,
3.  verify AI claims using evidence beyond the AI response,
4.  use follow-up questions to improve understanding,
5.  decide when enough evidence exists to accept, reject, or remain
    uncertain about an AI explanation.

This beginning/midpoint/end design reduces survey fatigue while
preserving a longitudinal view of perceived AI inquiry skill
development.

------------------------------------------------------------------------

# 17. Candidate Follow-Up Research Questions

The revised deployment supports a more mechanism-focused study than the
baseline characterization.

A follow-up study could organize its research questions around four
areas.

## RQ1 --- Does the revised DGL design preserve conceptual learning?

> **Do students continue to report meaningful conceptual gains under the
> revised 5C DGL structure, particularly across the software-to-hardware
> transition where the baseline study showed weaker gains?**

Of particular interest would be HW5--HW7.

The redesigned sequence explicitly attempts to make those gaps more
adjacent and connected.

A useful comparison would be whether the pronounced second-half decline
seen in the baseline becomes smaller.

## RQ2 --- Does Confront generate productive curiosity?

> **Do instructor demonstrations that expose a contradiction between the
> student's current model and observed behavior create curiosity that
> motivates subsequent investigation?**

The new DEMO item provides a direct self-report measure of this
mechanism.

Potential analyses include:

-   DEMO score versus retrospective gain,
-   DEMO score versus INV motivation category,
-   DEMO score versus depth of submitted AI investigation,
-   and DEMO score versus overall format preference.

This could help distinguish between a demonstration that is merely
memorable and one that actually initiates productive inquiry.

## RQ3 --- Do students develop AI inquiry skills over time?

> **Do students report increased confidence in asking follow-up
> questions, identifying questionable claims, verifying evidence, and
> determining when an explanation is sufficiently supported?**

The HW1/HW4/HW7 AI Investigation Skills battery provides a simple
repeated-measures structure.

More importantly, these self-reports could be compared with behavioral
evidence from submitted transcripts.

For example:

-   number and type of follow-up questions,
-   evidence of challenge/refinement,
-   use of external sources,
-   and quality of the Catch the AI verification.

This would directly address one of the most important limitations of the
baseline study.

## RQ4 --- Does the redesign reduce task-like fatigue?

> **Does the revised structure preserve deep AI engagement while
> reducing the decline in perceived learning value and the shift toward
> task-completion framing observed in the baseline deployment?**

Relevant measures include:

-   INV motivation across the term,
-   SCA format preference,
-   FAV component preference,
-   assignment completion patterns,
-   qualitative comments,
-   and transcript-derived engagement behavior.

The key outcome is not necessarily that students "like" every assignment
more.

A stronger result would be:

> deep engagement and conceptual gain remain high while fewer students
> experience the assignments primarily as repetitive task completion.

------------------------------------------------------------------------

# 18. Behavioral Cross-Validation

The most important methodological improvement would be to move beyond
self-report alone.

The baseline paper explicitly identifies cross-validation against
submitted Investigation Logs as an immediate next step.

The revised assignments continue to require the complete AI
conversation, creating an opportunity for systematic transcript
analysis.

Potential observable indicators include:

-   number of substantive follow-up turns,
-   proportion of prompts that refine or challenge previous responses,
-   explicit requests for evidence,
-   use of external sources,
-   corrections to AI explanations,
-   conceptual branching into student-initiated questions,
-   and whether the student's reported "best follow-up" corresponds to a
    meaningful transition in the transcript.

A coding scheme could distinguish interaction modes such as:

``` text
Retrieval
    "What is X?"

Clarification
    "Explain X another way."

Extension
    "How does X connect to Y?"

Challenge
    "That doesn't seem consistent with..."

Verification
    "What evidence supports that claim?"

Transfer
    "Would the same reasoning apply to...?"
```

This would allow the study to compare what students **say** they did
with what their submitted investigation actually contains.

------------------------------------------------------------------------

# 19. Measuring the Confront-to-Inquiry Path

A particularly interesting contribution of DGLv2 may be the ability to
study the complete learning path rather than only pre/post outcomes.

The hypothesized mechanism is:

``` text
Prior model
     |
     v
Prediction
     |
     v
Contradictory observation
     |
     v
Curiosity / unresolved question
     |
     v
AI-supported investigation
     |
     v
Critical verification
     |
     v
Revised conceptual model
```

Different measures correspond to different points in that path:

  Stage                          Potential evidence
  ------------------------------ ------------------------------
  Prior model                    B1
  Contradiction                  prediction + instructor demo
  Curiosity                      DEMO
  Motivation                     INV
  Investigation                  AI transcript
  Epistemic scrutiny             Catch the AI
  Conceptual change              P1 / Confirm performance
  Perceived learning mechanism   FAV
  Format sustainability          SCA
  AI inquiry development         AI1--AI5 at HW1/HW4/HW7

This creates the possibility of asking not only:

> **Did students report learning?**

but:

> **What path through the assignment was associated with that
> learning?**

------------------------------------------------------------------------

# 20. Demonstrated Mastery Versus Self-Reported Gain

The revised Confirm sections also create an opportunity to add a more
objective learning measure.

Each homework contains conceptual questions requiring students to:

-   reject a misconception,
-   explain the corrected model,
-   reason about a new case,
-   or apply an architectural tradeoff.

A follow-up study could score selected Confirm items using a common
conceptual-understanding rubric and compare those scores with
retrospective P1 ratings.

This would not eliminate all validity concerns, particularly because AI
is available during the homework, but it would provide another source of
evidence beyond self-report.

A stronger future design could include a delayed or AI-free transfer
item on an exam or later quiz.

That would allow a more rigorous question:

> **Does AI-supported investigation produce understanding that transfers
> beyond the AI-supported assignment context?**

------------------------------------------------------------------------

# 21. Comparison Conditions

The baseline study did not include a control condition, so it cannot
attribute observed gains specifically to DGL.

A future study could introduce a comparison at several levels.

Possible designs include:

## Assignment-level comparison

Comparable course sections or topics receive:

-   conventional homework,
-   baseline DGL,
-   or revised 5C DGL.

## Mechanism comparison

Both groups use AI, but only one receives the explicit Confront
demonstration.

This would isolate the value of the new deliberate-gap mechanism.

## Verification comparison

Both groups investigate with AI, but only one is graded on Catch the AI.

This could test whether explicit epistemic incentives change
verification behavior.

## Within-course crossover

Different topics use different homework formats, with order
counterbalanced where feasible.

Each design introduces tradeoffs in instructional fairness, sample size,
contamination, and administrative complexity.

The baseline study deliberately avoided these costs. A follow-up study
can now make a more targeted choice because the initial deployment
identified which mechanisms are most worth isolating.

------------------------------------------------------------------------

# 22. Important Hypotheses for the Follow-Up Study

The revised implementation suggests several testable hypotheses.

### H1 --- Confront predicts investigation motivation

Students who report stronger curiosity after the demonstration will be
more likely to characterize their investigation as understanding-driven
rather than completion-driven.

### H2 --- Curiosity predicts deeper observable AI engagement

Higher DEMO ratings will be associated with more substantive follow-up,
challenge, verification, and transfer behaviors in submitted
transcripts.

### H3 --- AI investigation skills increase over the course

AI1--AI5 ratings will increase from HW1 to HW4 to HW7.

### H4 --- Behavioral inquiry quality predicts conceptual outcomes

Students whose transcripts demonstrate deeper inquiry will show stronger
conceptual performance or reported gains than students whose transcripts
are primarily retrieval-oriented.

### H5 --- The revised hardware sequence reduces the baseline discontinuity

Reported and/or demonstrated gains on HW5--HW7 will be closer to the
first-half assignments than they were in the baseline deployment.

### H6 --- Reduced repetition improves format sustainability

SCA and related perception measures will decline less sharply across the
term than the baseline DGL ratings did.

These should be treated as candidate hypotheses rather than claims about
the revised model.

------------------------------------------------------------------------

# 23. What DGLv2 Is Not Trying to Prove

Several boundaries are important.

The follow-up study should not assume that:

-   positive student ratings imply learning,
-   AI use itself causes learning,
-   longer transcripts imply better inquiry,
-   every surprising demonstration produces productive curiosity,
-   self-reported AI confidence equals demonstrated AI literacy,
-   or DGL is superior to conventional homework in every course or
    topic.

The research question is more specific.

DGL proposes that homework can be redesigned so that AI-supported
inquiry becomes part of the intended intellectual work.

DGLv2 asks whether a more explicit curiosity-driven structure can
improve that model.

------------------------------------------------------------------------

# 24. Summary of the Evolution

The progression from baseline DGL to the revised model can be summarized
as follows:

  -----------------------------------------------------------------------
  Baseline DGL                        Revised DGL / DGLv2
  ----------------------------------- -----------------------------------
  Deliberate gap is defined by        Deliberate gap is made visible
  content omitted from lecture        through prediction and
                                      demonstration

  Lab provides the primary anchor     Connect explicitly activates the
                                      student's prior model

  Student moves directly into         Confront creates contradiction
  investigation                       before investigation

  Limited scaffold around the         Concept provides minimum scaffold
  uncovered topic                     to preserve adjacency

  Investigation Log emphasizes        Construct emphasizes scaffolded but
  documented prompt sequence          student-directed inquiry

  Synthesis is a major graded         Confirm uses multiple conceptual
  artifact                            and transfer-oriented measures

  Critical Check                      Catch the AI, preserving explicit
                                      epistemic scrutiny

  Connect It Back                     Connections are embedded throughout
                                      Connect, Construct, and Confirm

  Common survey after every homework  Short embedded feedback on every
                                      HW; AI-skills battery only
                                      HW1/HW4/HW7

  General format perception           Direct measure of whether the demo
                                      generated curiosity

  Engagement measured primarily by    Planned cross-validation with
  self-report                         submitted AI transcripts

  Seven identical structural          Same 5C conceptual model, but
  deployments                         demonstrations and investigations
                                      vary substantially by topic
  -----------------------------------------------------------------------

The underlying principle remains unchanged:

> **The purpose of AI in DGL is not to provide the answer. It is to
> support the student's process of constructing, questioning, verifying,
> and extending understanding.**

The revised model adds a more explicit mechanism for initiating that
process:

> **First make the gap visible. Then give the student a reason to
> investigate it.**

------------------------------------------------------------------------

# 25. Research Opportunity

The baseline study established that DGL is feasible at course scale and
can produce sustained critical AI engagement without custom AI
infrastructure. It also identified weaknesses that are unusually
actionable: adjacency matters, repetitive structure creates fatigue,
student expectations about AI and effort matter, and self-report needs
behavioral validation.

The revised deployment turns those findings into design changes rather
than simply repeating the original intervention.

That makes the follow-up study potentially more informative than a
simple replication.

The central research question becomes:

> **Can a deliberately engineered path from prior knowledge, to
> contradiction, to curiosity, to AI-supported inquiry produce both
> stronger conceptual continuity and more durable AI investigation
> skills?**

If the answer is yes, DGL becomes more than a way to make homework
resilient to generative AI.

It becomes a model for using generative AI to teach a professional skill
that conventional homework rarely measures directly:

> **how to encounter something you do not understand, ask progressively
> better questions, evaluate the answers critically, and build a
> defensible technical model of your own.**


------------------------------------------------------------------------

## 26. Research Ethics and Preprint Status

The original Deliberate Gap Learning (DGL) study was reviewed under **Drexel University IRB Protocol #2605011810** and was determined to qualify as **Category 2(i) exempt research**.

That study resulted in the manuscript provided in this directory as:

```text
original-dgl-preprint.pdf
```

This document is provided as an **author preprint** of the manuscript submitted for publication. Its availability here is consistent with the preprint policy of the journal to which the manuscript was submitted.

The revised DGL materials and proposed follow-up research described in this repository build upon that original study.

An updated IRB request is currently being prepared for the proposed follow-up research. The homework materials themselves are being developed and used as part of the normal course curriculum; the updated IRB request addresses the proposed research use of data generated through that course activity.

The appropriate review category for the follow-up study will be determined through Drexel University's institutional review process. No data from the follow-up implementation will be used for research purposes except in accordance with the applicable institutional review and approval requirements.