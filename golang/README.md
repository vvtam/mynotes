## 数组

函数之间传递数组，内存占用高，性能不好，可以使用**指针**，但是使用**切片**能更好的处理

## 切片

切片可以理解为动态数组

指向底层数组的指针，长度，容量

### 创建切片和初始化

- 使用make

```
// 创建一个字符切片
// 长度和容量都是5个元素
slice := make([]string, 5)
```

```
// 创建一个整型切片
// 长度为3，容量为5
slice := make([]int, 3, 5)
```

- 切片字面量声明切片

```
// 创建字符串切片
// 长度和容量都是5
slice := []string{"Red", "Blue", "Green", "Yellow", "Pink"}

// 创建一个整形切片
// 长度和容量都是3
slice := []int{10, 20, 30}
```

- 使用索引声明切片

  ```
  // 创建字符串切片
  // 使用空字符串初始化第100个元素
  slice := []string{99: ""}
  ```

  

### nil 和空切片

`var slice []int` //nil 切片

// 空切片

`slice := make([]int, 0)`

`slice := []int{}`

### 使用切片

- 切片容量少于1000个元素时，append操作的时候切片容量会成倍的增加
- 超过1000后，1.25 倍增加
- 以上可能随着版本变化会改变

- 使用三个索引创建切片

  ```
  // 创建字符串切片
  // 其长度和容量都是 5 个元素
  source := []string{"Apple", "Orange", "Plum", "Banana", "Grape"}
  
  // 将第三个元素切片，并限制容量
  // 其长度为 1 个元素，容量为 2 个元素
  slice := source[2:3:4] // 3-2, 4-2
  ```

  

- append 使用 `...`运算符

  ```
  // 创建两个切片，并分别用两个整数进行初始化
  s1 := []int{1, 2}
  s2 := []int{3, 4}
  // 将两个切片追加在一起，并显示结果
  fmt.Printf("%v\n", append(s1, s2...))
  Output:
  [1 2 3 4]
  ```

  

- 迭代切片

  for， range，range创建每个元素的副本

  ```
  // 创建一个整型切片
  // 其长度和容量都是 4 个元素
  slice := []int{10, 20, 30, 40}
  // 迭代每一个元素，并显示其值
  for index, value := range slice {
  fmt.Printf("Index: %d Value: %d\n", index, value)
  }
  Output:
  Index: 0 Value: 10
  Index: 1 Value: 20
  Index: 2 Value: 30
  Index: 3 Value: 40
  ```

  len()，cap()，处理数组，切片和通道

### 函数间传递切片

  x64系统上，传递切片只需24字节内存（指针8字节，长度和容量分别8字节），不涉及底层数组

## 映射

映射是一个存储键值对的无序集合

映射是一种数据结构，用于存储一系列无序的键值对，散列表实现，无序

基于键快速检索数据，就像索引一样

### 内部实现

### 创建和初始化

```
// 创建一个映射，键的类型是 string，值的类型是 int
dict := make(map[string]int)
// 创建一个映射，键和值的类型都是 string
// 使用两个键值对初始化映射
dict := map[string]string{"Red": "#da1337", "Orange": "#e95a22"}
```

### 使用映射

- 映射赋值

  ```
  // 创建一个空映射，用来存储颜色以及颜色对应的十六进制代码
  colors := map[string]string{}
  // 将 Red 的代码加入到映射
  colors["Red"] = "#da1337"
  ```

  

- nil映射不能赋值

  ```
  // 通过声明映射创建一个 nil 映射
  var colors map[string]string
  // 将 Red 的代码加入到映射
  colors["Red"] = "#da1337"
  Runtime Error:
  panic: runtime error: assignment to entry in nil map
  ```

  

- 判断键值是否存在

  ```
  // 获取键 Blue 对应的值
  value, exists := colors["Blue"]
  // 这个键存在吗？
  if exists {
  fmt.Println(value)
  }
  
  // 获取键 Blue 对应的值
  value := colors["Blue"]
  // 这个键存在吗？
  if value != "" {
  fmt.Println(value)
  }
  ```

- range迭代

  ```
  // 创建一个映射，存储颜色以及颜色对应的十六进制代码
  colors := map[string]string{
  "AliceBlue": "#f0f8ff",
  "Coral": "#ff7F50",
  "DarkGray": "#a9a9a9",
  "ForestGreen": "#228b22",
  }
  // 显示映射里的所有颜色
  for key, value := range colors {
  fmt.Printf("Key: %s Value: %s\n", key, value)
  }
  ```

  

### 函数间传递映射

不会制造副本

# 5 Go语言类型系统

## 5.2 方法

方法实际也是函数，只是声明的时候在func和方法名之间添加了一个参数，叫做*接收者*

方法能给用户自定义的类型添加新行为

函数有接收者，就被称为方法

函数与接收者的类型捆绑在一起

接收者分为**值接收者**，**指针接收者**

值接收者使用值的副本来调用方法，而指针接受者使用实际值来调用方法

## 5.3 类型的本质

### 引用类型

切片，映射，通道，接口，函数，指向底层数据结构的指针

## 5.4 接口