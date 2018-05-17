parse eye scoring for bars reward

Xdats like
```
#PubilSend adds 10, eventstrobe = 0
# lines like
# ...PupilSend(EVENTSTROBE+139)
# Name="FIVEPunishTarget426"   # 149

taskfile="/Volumes/L/bea_res/Tasks/Behavorial/chuck bar task 031708/Behavioral Value Bars with scoring - v. 1.es"
egrep "(Neu|FIVE).*Target" -B 1  "$taskfile" |grep Code -A 1|grep -v \- | perl -ne 'print $1+10, "\t" if /EVENTSTROBE\+(\d+)/; print $_ if s/Name=//'
# 202     "NeutralTarget214"
# 203     "NeutralTarget426"
# 204     "NeutralTarget532"
# 201     "NeutralTarget108"

# 128     "FIVERewardTarget214"
# 127     "FIVERewardTarget108"
# 129     "FIVERewardTarget426"
# 130     "FIVERewardTarget532"

# 147     "FIVEPunishTarget108"
# 148     "FIVEPunishTarget214"
# 149     "FIVEPunishTarget426"
# 150     "FIVEPunishTarget532"
```
