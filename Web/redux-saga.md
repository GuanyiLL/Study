# Redux Saga Note

## Using Saga Helper

```js
import { takeEvery, call, put } from 'redux-saga/effects'

export function* fetchData(action) {
   try {
      const data = yield call(Api.fetchUser, action.payload.url)
      yield put({type: "FETCH_SUCCEEDED", data})
   } catch (error) {
      yield put({type: "FETCH_FAILED", error})
   }
}
function* watchFetchData() {
  yield takeEvery('FETCH_REQUESTED', fetchData)
}
```

上面这个例子中, `takeEvery` 允许多个 `fetchData` 实例异步执行。 在任何时刻, 我们都可以发起一个新的`fetchData`任务， 尽管之前的`fetchData`任务还没有结束。

如果我们只想得到最后一次任务的响应结果，那么可以使用`takeLatest`方法：

```js
import { takeLatest } from 'redux-saga/effects'

function* watchFetchData() {
  yield takeLatest('FETCH_REQUESTED', fetchData)
}
```

还可以像这样，监听多个action：

```js
import { takeEvery } from 'redux-saga/effects'

// FETCH_USERS
function* fetchUsers(action) { ... }

// CREATE_USER
function* createUser(action) { ... }

// use them in parallel
export default function* rootSaga() {
  yield takeEvery('FETCH_USERS', fetchUsers)
  yield takeEvery('CREATE_USER', createUser)
}
```