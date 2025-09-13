import Toy.TreeEngine

def foo := #tree .leaf .a

def bar := #tree .node (.leaf .a) (.node (.leaf .a) (.leaf .b))

def baz := #tree .node (.leaf .c) (.node (.leaf .a) (.leaf .b))

def large := #tree .node
  (.node
    (.node
      (.node (.node (.leaf .a) (.node (.leaf .a) (.leaf .b))) (.node (.leaf .c) (.node (.leaf .a) (.leaf .b))))
      (.node (.node (.leaf .c) (.node (.leaf .a) (.leaf .b))) (.node (.leaf .c) (.node (.leaf .a) (.leaf .d)))))
    (.node
      (.node (.node (.leaf .c) (.node (.leaf .a) (.leaf .b))) (.node (.leaf .b) (.node (.leaf .a) (.leaf .b))))
      (.node (.node (.leaf .a) (.node (.leaf .a) (.leaf .b))) (.node (.leaf .b) (.node (.leaf .a) (.leaf .d))))))
  (.node
    (.node
      (.node (.node (.leaf .a) (.node (.leaf .a) (.leaf .b))) (.node (.leaf .c) (.node (.leaf .a) (.leaf .b))))
      (.node (.node (.leaf .c) (.node (.leaf .a) (.leaf .b))) (.node (.leaf .b) (.node (.leaf .a) (.leaf .d)))))
    (.node
      (.node (.node (.leaf .c) (.node (.leaf .a) (.leaf .b))) (.node (.leaf .b) (.node (.leaf .a) (.leaf .b))))
      (.node (.node (.leaf .c) (.node (.leaf .a) (.leaf .b))) (.node (.leaf .b) (.node (.leaf .a) (.leaf .d))))))
