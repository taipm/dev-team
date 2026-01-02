# Team Step Template

Templates cho các steps trong team workflow.

---

## Step 01: Session Init

```markdown
# Step 01: Session Initialization

## Trigger
Khi user gọi `/microai:{team_name}-session {topic}`

## Actions

1. **Parse Input**
   - Extract topic từ user input
   - Detect mode từ keywords

2. **Load Context**
   - Read `memory/context.md`
   - Check for active session

3. **Load Agents**
   - Load agent personas từ `agents/`
   - Assign roles based on mode

4. **Load Knowledge**
   - Base knowledge cho mode
   - On-demand theo keywords

5. **Display Welcome**
   ```
   ╔═══════════════════════════════════════════════════════════════╗
   ║                 {TEAM_NAME} SESSION                           ║
   ╠═══════════════════════════════════════════════════════════════╣
   ║  Mode: {detected_mode}                                        ║
   ║  Topic: {topic}                                               ║
   ╠═══════════════════════════════════════════════════════════════╣
   ║  {Agent1.icon} {Agent1.name} - {Agent1.role}                  ║
   ║  {Agent2.icon} {Agent2.name} - {Agent2.role}                  ║
   ╚═══════════════════════════════════════════════════════════════╝
   ```

## Next Step
→ Step 02: Topic Presentation
```

---

## Step 02: Topic Presentation

```markdown
# Step 02: Topic Presentation

## Trigger
Sau Step 01 hoàn thành

## Actions

1. **Determine First Speaker**
   - Dựa vào mode
   - Dựa vào topic keywords

2. **First Speaker Presents**
   - Agent trình bày topic
   - Cung cấp context và constraints
   - Đặt câu hỏi mở cho agent khác

3. **Display Format**
   ```
   ┌─────────────────────────────────────────────────────────────┐
   │ {Agent.icon} {Agent.name}:                                   │
   ├─────────────────────────────────────────────────────────────┤
   │ {presentation_content}                                       │
   │                                                              │
   │ Questions for {OtherAgent.name}:                             │
   │ 1. {question_1}                                              │
   │ 2. {question_2}                                              │
   └─────────────────────────────────────────────────────────────┘
   ```

## Next Step
→ Step 03: Dialogue Loop
```

---

## Step 03: Dialogue Loop

```markdown
# Step 03: Dialogue Loop

## Trigger
Sau presentation, enter dialogue mode

## Loop Structure

```
while (not consensus AND turn_count < max_turns):
    1. Current agent responds
    2. Display response
    3. Wait for observer input
    4. Handle observer command OR continue
    5. Switch speaker
    6. Checkpoint
```

## Turn Format
```
┌─ Turn {n} ─────────────────────────────────────────────────────┐
│ {Agent.icon} {Agent.name}:                                      │
├─────────────────────────────────────────────────────────────────┤
│ {response_content}                                              │
└─────────────────────────────────────────────────────────────────┘

[Enter to continue | @agent: inject | *skip | *exit]
```

## Consensus Detection
- Cả hai agents đồng ý trên key points
- Không còn open questions
- Action items clear

## Exit Conditions
- Consensus reached
- Max turns (default: 10)
- Observer *skip or *exit

## Next Step
→ Step 04: Output Synthesis
```

---

## Step 04: Output Synthesis

```markdown
# Step 04: Output Synthesis

## Trigger
- Consensus reached
- OR max turns
- OR *skip command

## Actions

1. **Collect Key Points**
   - Extract agreements từ dialogue
   - List action items
   - Note any unresolved issues

2. **Generate Output**
   - Load appropriate template
   - Fill in collected data
   - Both agents "sign off"

3. **Display Preview**
   ```
   ╔═══════════════════════════════════════════════════════════════╗
   ║                    OUTPUT PREVIEW                              ║
   ╠═══════════════════════════════════════════════════════════════╣
   {output_content}
   ╠═══════════════════════════════════════════════════════════════╣
   ║ ✓ {Agent1.name} approved                                      ║
   ║ ✓ {Agent2.name} approved                                      ║
   ╚═══════════════════════════════════════════════════════════════╝
   ```

## Next Step
→ Step 05: Session Close
```

---

## Step 05: Session Close

```markdown
# Step 05: Session Close

## Trigger
Sau Step 04 hoàn thành

## Actions

1. **Save Output**
   - Write to `logs/{date}-{mode}-{topic}.md`

2. **Update Memory**
   - Append to `memory/sessions.md`
   - Update `memory/context.md`
   - Add patterns to `memory/learnings.md`

3. **Display Summary**
   ```
   ╔═══════════════════════════════════════════════════════════════╗
   ║                    SESSION COMPLETE                           ║
   ╠═══════════════════════════════════════════════════════════════╣
   ║  Duration: {duration}                                         ║
   ║  Turns: {turn_count}                                          ║
   ║  Output: logs/{output_file}                                   ║
   ╠═══════════════════════════════════════════════════════════════╣
   ║  Key Decisions:                                               ║
   ║  • {decision_1}                                               ║
   ║  • {decision_2}                                               ║
   ╚═══════════════════════════════════════════════════════════════╝
   ```

4. **Cleanup**
   - Archive checkpoint files
   - Clear session state

## End
Session complete.
```
