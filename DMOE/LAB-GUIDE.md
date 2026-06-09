# IBM Decision Manager Open Edition (DMOE/BAMOE) Custom Mode Lab Guide

## Objective

Validate that the DMOE/BAMOE custom mode can:

1. Guide users through BAMOE installation.
2. Generate a DMN decision model from business requirements.
3. Generate a complete Maven project.
4. Create test data.
5. Evaluate decision outcomes.
 

---

# Prerequisites

## 1. Import Custom Mode

Import the DMOE/BAMOE custom mode YAML into BOB.

## 2. Select Custom Mode

From the BOB mode dropdown select:

```text
IBM Decision Manager Open Edition (DMOE/BAMOE)
```

---

# Test 1: BAMOE Installation Validation

## Prompt

```text
I am new to IBM Decision Manager Open Edition.

Guide me through the complete installation process for BAMOE 9.2.1-ibm-0005 on my local machine.

Include:
- BAMOE Maven repository setup
- Maven configuration
- Java requirements
- Verification steps
```

## Expected Result

The agent should provide:

* Java 17 requirement
* Podman installation
* BAMOE Maven repository setup

Example:

```bash
podman pull quay.io/bamoe/maven-repository:9.2.1-ibm-0005

podman run -d \
  --name bamoe-maven-repo \
  -p 9011:8080 \
  quay.io/bamoe/maven-repository:9.2.1-ibm-0005
```

and explain Maven configuration.

---

# Test 2: Generate DMOE Project From Business Rules

## Prompt

```text
Create a complete IBM Decision Manager Open Edition project for the following business rules.

Business Requirement:

Determine whether a member is eligible for a Diabetes Wellness Program.

Business Rules:

Age >= 40
AND Has Diabetes = true
AND BMI >= 30

Then ELIGIBLE

Otherwise NOT ELIGIBLE

Generate:

- pom.xml
- kmodule.xml
- DMN file
- Java classes
- DMNConfig.java
- App.java
- Sample test data
```

## Expected Result

The agent generates:

```text
pom.xml
src/main/resources/rules/DiabetesWellnessProgram.dmn
DMNConfig.java
MemberModel.java
App.java
```

---

# Test 3: Explain Generated Project

## Prompt

```text
Explain the generated project and describe the role of each file.
```

## Expected Result

Agent explains:

```text
pom.xml
DMN file
DMNConfig.java
MemberModel.java
App.java
kmodule.xml
```

and the execution flow.

---

# Test 4: Generate Test Data

## Prompt

```text
Generate five test records for DiabetesWellnessProgram.dmn.

Include expected outputs.
```

## Expected Result

| Member | Age | Diabetes | BMI | Expected     |
| ------ | --- | -------- | --- | ------------ |
| 1001   | 45  | true     | 32  | ELIGIBLE     |
| 1002   | 35  | true     | 32  | NOT ELIGIBLE |
| 1003   | 50  | false    | 40  | NOT ELIGIBLE |
| 1004   | 55  | true     | 35  | ELIGIBLE     |
| 1005   | 60  | true     | 28  | NOT ELIGIBLE |

---

# Test 5: Decision Evaluation

## Prompt

```text
Evaluate the following member against the existing DiabetesWellnessProgram.dmn.

{
  "memberId": "1001",
  "age": 45,
  "hasDiabetes": true,
  "bmi": 32
}
```

## Expected Result

```text
ELIGIBLE
```

with explanation:

```text
Age >= 40      ✓
Has Diabetes   ✓
BMI >= 30      ✓
```

---

# Test 6: Rule Change

## Prompt

```text
Modify the business rule.

New Rule:

Age >= 50
AND Has Diabetes = true
AND BMI >= 35

Update only the DMN model and regenerate test results.
```

## Expected Result

Agent updates only the DMN logic and regenerates results.

---





# Success Criteria

The lab is considered successful if the custom mode can:

✓ Explain BAMOE installation

✓ Generate a complete DMOE project

✓ Create a valid DMN model

✓ Generate test data

✓ Evaluate decision outcomes

✓ Focus on implementation rather than tutorials or study guides
