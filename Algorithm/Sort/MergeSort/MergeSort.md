# 归并算法

* 最坏时间复杂度   O(nlogn)
* 最优时间复杂度   O(n)
* 平均时间复杂度   O(nlogn)
* 空间复杂度      O(n)

## 归并操作
归并操作（merge），也叫归并算法，指的是将两个已经排序的序列合并成一个序列的操作。归并排序算法依赖归并操作。
### 迭代法
1. 申请空间，使其大小为两个已经排序序列之和，该空间用来存放合并后的序列
2. 设定两个指针，最初位置分别为两个已经排序序列的起始位置
3. 比较两个指针所指向的元素，选择相对小的元素放入到合并空间，并移动指针到下一位置
4. 重复步骤3直到某一指针到达序列尾
5. 将另一序列剩下的所有元素直接复制到合并序列尾

### 递归法
原理如下（假设序列共有n个元素）：
1. 将序列每相邻两个数字进行归并操作，形成ceil(n/2)个序列，排序后每个序列包含两/一个元素
2. 若此时序列数不是1个则将上述序列再次归并，形成ceil(n/4)个序列，每个序列包含四/三个元素
3. 重复步骤2，直到所有元素排序完毕，即序列数为1

## 算法复杂度
比较操作的次数介于(nlogn)/2和nlogn-n+1。赋值操作的次数是(2nlogn)。归并算法的空间复杂度为：O(n)

## Code

```c++
//迭代版

void merge_sort(int arr[], int len) {
    int* a = arr;
	  int* b = new int[len];
	  for (int seg = 1; seg < len; seg += seg) {
		    for (int start = 0; start < len; start += seg + seg) {
			      int low = start, mid = min(start + seg, len), high = min(start + seg + seg, len);
			      int k = low;
			      int start1 = low, end1 = mid;
			      int start2 = mid, end2 = high;
			      while (start1 < end1 && start2 < end2)
				    b[k++] = a[start1] < a[start2] ? a[start1++] : a[start2++];
			      while (start1 < end1)
				        b[k++] = a[start1++];
			      while (start2 < end2)
				        b[k++] = a[start2++];
        }
		    int* temp = a;
		    a = b;
		    b = temp;
    }
	  if (a != arr) {
		    for (int i = 0; i < len; i++)
			      b[i] = a[i];
		    b = a;
	  }
	  delete[] b;
}

//递归版：

void merge_sort_recursive(int arr[], int reg[], int start, int end) {
    if (start >= end)
        return;
    int len = end - start, mid = (len >> 1) + start;
	  int start1 = start, end1 = mid;
	  int start2 = mid + 1, end2 = end;
	  merge_sort_recursive(arr, reg, start1, end1);
	  merge_sort_recursive(arr, reg, start2, end2);
	  int k = start;
	  while (start1 <= end1 && start2 <= end2)
		    reg[k++] = arr[start1] < arr[start2] ? arr[start1++] : arr[start2++];
	  while (start1 <= end1)
		    reg[k++] = arr[start1++];
	  while (start2 <= end2)
		    reg[k++] = arr[start2++];
	  for (k = start; k <= end; k++)
		    arr[k] = reg[k];
}

void merge_sort(int arr[], const int len) {
	  int reg[len];
	  merge_sort_recursive(arr, reg, 0, len - 1);
}

```
