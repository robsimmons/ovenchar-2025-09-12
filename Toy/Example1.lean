import Toy.TreeEngine

def foo := #tree .leaf 0

def bar := #tree .node (.leaf 0) (.node (.leaf 0) (.leaf 1))

def baz := #tree .node (.leaf 2) (.node (.leaf 0) (.leaf 1))

def large := #tree .node
  (.node
    (.node
      (.node
        (.node (.node (.leaf 0) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))))
        (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 2) (.node (.leaf 0) (.leaf 3)))))
      (.node
        (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 1))))
        (.node (.node (.leaf 0) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 3))))))
    (.node
      (.node
        (.node (.node (.leaf 0) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))))
        (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 3)))))
      (.node
        (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 1))))
        (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 3)))))))
  (.node
    (.node
      (.node
        (.node
          (.node (.node (.leaf 0) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))))
          (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 2) (.node (.leaf 0) (.leaf 3)))))
       (.node
          (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 1))))
          (.node (.node (.leaf 0) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 3))))))
      (.node
        (.node
          (.node (.node (.leaf 0) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))))
          (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 3)))))
        (.node
          (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 1))))
          (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 3)))))))
    (.node
      (.node
        (.node
          (.node (.node (.leaf 0) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))))
          (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 2) (.node (.leaf 0) (.leaf 3)))))
       (.node
          (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 1))))
          (.node (.node (.leaf 0) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 3))))))
      (.node
        (.node
          (.node (.node (.leaf 0) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))))
          (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 3)))))
        (.node
          (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 1))))
          (.node (.node (.leaf 2) (.node (.leaf 0) (.leaf 1))) (.node (.leaf 1) (.node (.leaf 0) (.leaf 3))))))))
