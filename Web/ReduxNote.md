# 基础

## Action

**Action**是把数据从应用传到`store`的有效载荷。它是`store`数据的唯一来源。一般来说你会通过`store.dispatch()`将`action`传到`store`。

添加新`todo`任务的`action`：

```js
const ADD_TODO = 'ADD_TODO'

{
  type: ADD_TODO,
  text: 'Build my first Redux app'
}
```

建议使用单独的模板块或文件来存放`action`:

```js
import { ADD_TODO, REMOVE_TODO } from '../actionTypes'
```

这时，我们还需要再添加一个`action index`来表示用户完成任务的动作序列号。因为数据是存放在数组中的，所以我们通过下标`index`来引用特定的任务。而实际项目中一般会在新建数据的时候生成唯一的`ID`作为数据的引用标识。

```js
{
  type: TOGGLE_TODO,
  index: 5
}
```

我们应该尽量减少在`action`中传递的数据。比如上面的例子，传递`index`就比把整个任务对象传过去要好。

最后，再添加一个`action type`来表示当前的任务展示选项

```js
{
  type: SET_VISIBILITY_FILTER,
  filter: SHOW_COMPLETED
}
```

## Action 创建函数

**Action 创建函数**就是生成`action`的方法。`action`和`action创建函数`这两个概念很容易混在一起，使用时最好注意区分。

在`Redux`中的`action`创建函数只是简单的返回一个action:

```js
function addTodo(text) {
  return {
    type: ADD_TODO,
    text
  }
}
```

这样做将使 action 创建函数更容易被移植和测试。

Redux 中只需把 action 创建函数的结果传给 dispatch() 方法即可发起一次 dispatch 过程。

```js
dispatch(addTodo(text))
dispatch(completeTodo(index))
```

或者创建一个 被绑定的 action 创建函数 来自动 dispatch：

```js
const boundAddTodo = text => dispatch(addTodo(text))
const boundCompleteTodo = index => dispatch(completeTodo(index))
```

然后直接调用它们：

```js
boundAddTodo(text);
boundCompleteTodo(index);
```

## Reducer

`Reducers`指定了应用状态的彼岸花如何响应`actions`并发送到`store`,`actions`只是描述了有事情发生了这一事实，并没有描述应用如何更新`state`。

### 设计 State 结构

在`Redux`应用中，所有的`state`都被保存在一个单一对象中。建议在写代码前先想一下这个对象的结构。如何才能以最简的形式把应用的`state`用对象描述出来？

以`todo`应用为例，需要保存两种不同的数据：

1. 当前选中的任务过滤条件；
2. 完整的任务列表。

通常，这个`state`树还需要存放其它一些数据，以及一些`UI`相关的`state`。这样做没问题，但尽量把这些数据与`UI`相关的`state`分开。

```js
{
  visibilityFilter: 'SHOW_ALL',
  todos: [
    {
      text: 'Consider using Redux',
      completed: true,
    },
    {
      text: 'Keep all state in a single tree',
      completed: false
    }
  ]
}
```

### Action 处理

现在我们已经确定了`state`对象的结构，就可以开始开发`reducer`。`reducer`就是一个纯函数，接收旧的`state`和`action`，返回新的`state`。

```js
(previousState, action) => newState
```

reducer为纯函数，不要做以下操作：

* 修改传入参数
* 执行有副作用，如API请求和路由跳转
* 调用非纯函数，如`Date.now()`或`Math.random()`

Redux 首次执行时`state`为`undefined`，此时我们可借机设置并返回应用的初始`state`。

```js
import { VisibilityFilters } from './actions'

const initialState = {
  visibilityFilter: VisibilityFilters.SHOW_ALL,
  todos: []
};

function todoApp(state = inistailState, action) {
  // 这里暂不处理任何 action，
  // 仅返回传入的 state。
  return state
}
```

现在可以处理`SET_VISIBILITY_FILTER`。需要做的只是改变`state`中的`visibilityFilter`。

```js
function todoApp(state = initialState, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return Object.assign({}, state, {
        visibilityFilter: action.filter
      })
    default:
      return state
  }
}
```

注意：

1. 不要修改`state`,使用`Object.assign()`新建了一个副本。不能这样使用`Object.assign(state, {visibilityFilter: action.filter})`，因为它会改变第一个参数的值，必须把第一个参数设置为空对象。也可以使用对象展开云算符从而使用`{...state,...newstate}`达到同样的目的。
2. 在`default`情况下返回旧的`state`。遇到未知的`action`时，一定要返回旧的`state`。

### 处理多个action

还有两个`action`需要处理。就像我们处理`SET_VISIBILITY_FILTER`一样，我们引入`ADD_TODO`和`TOGGLE_TODO`两个`actions`并且扩展我们的`reducer`去处理`ADD_TODO`。

```js
import {
  ADD_TODO,
  TOGGLE_TODO,
  SET_VISIBILITY_FILTER,
  VisibilityFilters
} from './actions'

...

function todoApp(state = initialState, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return Object.assign({}, state, {
        visibilityFilter: action.filter
      })
    case ADD_TODO:
      return Object.assign({}, state, {
        todos: [
          ...state.todos,
          {
            text: action.text,
            completed: false
          }
        ]
      })
    default:
      return state
  }
}
```

如上，不直接修改`state`中的字段，而是返回新对象。新的`todos`对象就相当于旧的`todos`在末尾加上新建的`todo`。而这个新的`todo`又是基于`action`中的数据创建的。

最后,`TOGGLE_TODO`的实现也很好理解：

```js
case TOGGLE_TODO:
  return Object.assign({}, state, {
    todos: state.todos.map((todo, index) => {
      if (index === action.index) {
        return Object.assign({}, todo, {
          completed: !todo.completed
        })
      }
      return todo
    })
  })
```

### 拆分 Reducer

这里的`todos`和`visibilityFilter` 的更新看起来是相互独立的。有时`state`中的字段是相互依赖的，需要认真考虑，但在这个案例中我们可以把`todos`更新的业务逻辑拆分到一个单独的函数里：

```js
function todos(state = [], action) {
  switch (action.type) {
    case ADD_TODO:
      return [
        ...state,
        {
          text: action.text,
          completed: false
        }
      ]
    case TOGGLE_TODO:
      return state.map((todo, index) => {
        if (index === action.index) {
          return Object.assign({}, todo, {
            completed: !todo.completed
          })
        }
        return todo
      })
    default:
      return state
  }
}

function todoApp(state = initialState, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return Object.assign({}, state, {
        visibilityFilter: action.filter
      })
    case ADD_TODO:
      return Object.assign({}, state, {
        todos: todos(state.todos, action)
      })
    case TOGGLE_TODO:
      return Object.assign({}, state, {
        todos: todos(state.todos, action)
      })
    default:
      return state
  }
}
```

注意`todos`依旧接收`state`，但它变成了一个数组！现在`todoApp`只把需要更新的一部分`state`传给`todos`函数`todos`函数自己确定如何更新这部分数据。**这就是所谓的`reducer`合成，它是开发`Redux`应用最基础的模式**。

下面深入探讨一下如何做`reducer`合成。能否抽出一个`reducer`来专门管理`visibilityFilter`?当然可以：

```js
function todos(state = [], action) {
  switch (action.type) {
    case ADD_TODO:
      return [
        ...state,
        {
          text: action.text,
          completed: false
        }
      ]
    case TOGGLE_TODO:
      return state.map((todo, index) => {
        if (index === action.index) {
          return Object.assign({}, todo, {
            completed: !todo.completed
          })
        }
        return todo
      })
    default:
      return state
  }
}

function visibilityFilter(state = SHOW_ALL, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return action.filter
    default:
      return state
  }
}

function todoApp(state = {}, action) {
  return {
    visibilityFilter: visibilityFilter(state.visibilityFilter, action),
    todos: todos(state.todos, action)
  }
}
```

注意每个`reducer`只负责管理全局`state`中它负责的一部分。每个`reducer`的`state`参数都不同，分别对应它管理的那部分`state`数据。

现在看起来好多了！随着应用的膨胀，我们还可以将拆分后的`reducer`放到不同的文件中, 以保持其独立性并用于专门处理不同的数据域。

最后,`Redux`提供了`combineReducers()`工具类来做上面`todoApp`做的事情，这样就能消灭一些样板代码了。有了它，可以这样重构todoApp：

```js
import { combineReducers } from 'redux'

const todoApp = combineReducers({
  visibilityFilter,
  todos
})

export default todoApp
```

## Store

Store 有以下职责：

* 维持应用的 state；
* 提供 getState() 方法获取 state；
* 提供 dispatch(action) 方法更新 state；
* 通过 subscribe(listener) 注册监听器;
* 通过 subscribe(listener) 返回的函数注销监听器。

再次强调一下`Redux`应用只有一个单一的`store`。当需要拆分数据处理逻辑时，你应该使用`reducer`组合 而不是创建多个`store`。

将前面的`reducer`导入，并传递给`createStore()`来创建`store`，`createStore()`的第二个参数是可选的, 用于设置`state`初始状态。这对开发同构应用时非常有用，服务器端`redux`应用的`state`结构可以与客户端保持一致, 那么客户端可以将从网络接收到的服务端`state`直接用于本地数据初始化。

```js
import { createStore } from 'redux'
import todoApp from './reducers'

let store = createStore(todoApp, window.STATE_FROM_SERVER)
```

## 数据流

严格的单向数据流是`Redux`架构的设计核心。

`Redux`应用中数据的生命周期遵循下面4个步骤：

1. 调用`store.dispatch(action)`.
2. `Redux store`调用传入的`reducer`函数。
3. 根`reducer`应该把多个子`reducer`输出合并成一个单一的`state`树。
4. `Redux store`保存了根`reducer`返回的完整`state`树。
