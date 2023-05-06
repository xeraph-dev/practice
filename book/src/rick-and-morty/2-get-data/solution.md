# My solution in JavaScript

## Script to get the data

**File**: `<root>/database/download.mjs`

_Base file with all the imports and variables that I will use._

```javascript
{{#include ../../../../rick-and-morty/database/download.mjs:0:26}}
```

_`getItems` function to recursively fetch all records_

```javascript
{{#include ../../../../rick-and-morty/database/download.mjs:28:35}}
```

_`saveImage` function to download character's image_

```javascript
{{#include ../../../../rick-and-morty/database/download.mjs:37:46}}
```

_Using the `getItems` function to download the character dataset and images_

```javascript
{{#include ../../../../rick-and-morty/database/download.mjs:48:61}}
```

_Using the `getItems` function to download the episode dataset_

```javascript
{{#include ../../../../rick-and-morty/database/download.mjs:63:70}}
```

_Using the `getItems` function to download the location dataset_

```javascript
{{#include ../../../../rick-and-morty/database/download.mjs:72:79}}
```

## Script to get stats

**File**: `<root>/database/stats.mjs`

_Stats object variable and import json files_

```javascript
{{#include ../../../../rick-and-morty/database/stats.mjs:0:37}}
```

_Compute characters stats_

```javascript
{{#include ../../../../rick-and-morty/database/stats.mjs:39:57}}
```

_Compute locations stats_

```javascript
{{#include ../../../../rick-and-morty/database/stats.mjs:59:69}}
```

_Compute episodes stats_

```javascript
{{#include ../../../../rick-and-morty/database/stats.mjs:71:78}}
```

_Show characters stats_

```javascript
{{#include ../../../../rick-and-morty/database/stats.mjs:82:96}}
```

_Characters stats output_

| Question                  | Answer                              |
| ------------------------- | ----------------------------------- |
| **Names repeated**        | `46`                                |
| **Name is Unique?**       | `false`                             |
| **Statuses**              | `Alive, unknown, Dead`              |
| **Genders**               | `Male, Female, unknown, Genderless` |
| **Species**               | `10`                                |
| **Types**                 | `169`                               |
| **Status can be null?**   | `false`                             |
| **Gender can be null?**   | `false`                             |
| **Species can be null?**  | `false`                             |
| **Type can be null?**     | `true`                              |
| **Location can be null?** | `true`                              |
| **Origin can be null?**   | `true`                              |
| **Image can be null?**    | `false`                             |

_Show locations stats_

```javascript
{{#include ../../../../rick-and-morty/database/stats.mjs:101:108}}
```

_Locations stats output_

| Question                   | Answer |
| -------------------------- | ------ |
| **Names repeated**         | `0`    |
| **Name is Unique?**        | `true` |
| **Types**                  | `45`   |
| **Dimensions**             | `33`   |
| **Type can be null?**      | `true` |
| **Dimension can be null?** | `true` |

_Show episodes stats_

```javascript
{{#include ../../../../rick-and-morty/database/stats.mjs:113:117}}
```

_Episodes stats output_

| Question                 | Answer  |
| ------------------------ | ------- |
| **Names repeated**       | `0`     |
| **Name is Unique?**      | `true`  |
| **Episode can be null?** | `false` |
