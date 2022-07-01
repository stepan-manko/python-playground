1. In the current assumption the problem has a threshold beyond which it is unsolvable.
Indeed, everything depends on how often the trading platform is generating trades/messages.
E.g. if they generate fast enough, or the buffer is small enough; we will be getting
an error oftentimes;

2. Also, if the trading platform will generate more messages per same timestamp than the
throughput of the query method (currently more than 100), we won't be able to get
a historical data. So its worth changing the method to return all remaining
messages with the same timestamp as the 100th one.

3. We should create a storage (e.g. Redis), where we store everything 
coming from realtimeUpdates. Namely, my application should have a listener for realtimeUpdates
and as soon as something is returned from it, we store it in Redis

4. Next, we should iterate over two lists: the historical data from query and the ones 
from buffer (which are stored in Redis).
The iterator over the historical data has the current map:
{timestamp: [id1, id2, id3]}
E.g.
current_map = {timestamp1: [id1]},
if the next trade of id2 has also timestamp1, then
current_map = {timestamp1: [id1, id2]},
if the next trade of id3 has timestamp3 !== timestamp1, then
current_map = {timestamp3: [id3]}.

Assume we need to make 3 calls of query method:
first call with the `since` timestamp, all others are with the timestamp of the last
element from the previous response.

The iteration over the first response is described above. In the end we have
current_map = {timestamp_last_element: [id_x, id_y, id_last_element]}.
The next call of query is coming with timestamp_last_element, and of course we skip first 
few elements with ids from the current_map, not adding them to the final iterator.

As soon as we exhaust all historical data, we go to redis. Of course, we skipp all
elements with smaller timestamp than timestamp_last_element, and skipping ids that are in 
the current_map. 
