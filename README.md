# Usage Guide - Blockchain Voting System

## 🚀 Remix Setup

1. In the "Deploy & Run Transactions" tab
2. Choose "Remix VM (London)" as environment
3. Select `VotingSystem` from the dropdown
4. Click "Deploy"

## 📝 Complete Testing Scenario

### Phase 1: Setup (Administrator)

**1. Add candidates:**
```
addCandidate("Alice Smith")
addCandidate("Bob Johnson")
addCandidate("Claire Wilson")
```

**2. Authorize voters:**
```
authorizeVoter(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
authorizeVoter(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2)
authorizeVoter(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db)
```

**3. Open voting:**
```
openVoting()
```

### Phase 2: Voting (Voters)

**Switch accounts in Remix and vote:**
- Account 1 votes for candidate 0: `vote(0)`
- Account 2 votes for candidate 1: `vote(1)`
- Account 3 votes for candidate 0: `vote(0)`

### Phase 3: Results

**Check results:**
```
getResults() // View all results
getWinner() // Winner's ID and name
getStatistics() // General stats
```

## 🔧 Main Functions

### For Administrator
| Function | Description |
|----------|-------------|
| `addCandidate(name)` | Add a candidate |
| `authorizeVoter(address)` | Authorize a voter |
| `openVoting()` | Open voting |
| `closeVoting()` | Close voting |

### For Voters
| Function | Description |
|----------|-------------|
| `vote(candidateId)` | Vote for a candidate |
| `hasAlreadyVoted(address)` | Check if someone voted |

### Public Consultation
| Function | Description |
|----------|-------------|
| `getCandidate(id)` | Candidate info |
| `getResults()` | All results |
| `getWinner()` | Winner's ID and name |
| `getStatistics()` | Voting stats |

## 🛡️ Security Features

1. **Single vote:** Impossible to vote twice
2. **Authorization:** Only authorized voters can vote
3. **Administration:** Only admin can manage voting
4. **Voting states:** Can only vote when voting is open
5. **Validation:** All parameters are verified

## 🧪 Tests to Perform

### Security Tests
1. ✅ Try to vote twice (should fail)
2. ✅ Vote without authorization (should fail)
3. ✅ Add candidate during voting (should fail)
4. ✅ Vote for non-existent candidate (should fail)

### Functional Tests
1. ✅ Correct vote counting
2. ✅ Correct winner identification
3. ✅ Results display
4. ✅ Voting state management

## 📊 Simulation Example

**Setup:**
- 3 candidates: Alice, Bob, Claire
- 5 authorized voters

**Votes:**
- 2 votes for Alice
- 1 vote for Bob  
- 2 votes for Claire

**Expected result:**
- Tie between Alice and Claire (2 votes each)
- The `getWinner()` function will return the smallest ID in case of tie