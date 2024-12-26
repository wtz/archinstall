#!/bin/sh

# 设置要维护的工作区数量
WINDOW_LIMIT=2

# 处理窗口创建的逻辑
handle_new_window() {

  current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
  last_window=$(hyprctl activeworkspace -j | jq -r '.lastwindow')
  float_window_count=$(hyprctl clients -j | jq '[.[] | select(.floating == true)] | length')

  # 当前工作区的窗口数
  local current_window_count_1=$(hyprctl activeworkspace -j | jq -r '.windows')
  current_window_count=$((current_window_count_1 - float_window_count))

  # 打印窗口数量
  # echo "Current workspace: $current_workspace, 排除floatwindow count: $current_window_count"

  if [ "$current_window_count" -gt "$WINDOW_LIMIT" ]; then

    next_workspace=$((current_workspace + 1))
    next_window_count=$(hyprctl workspaces -j | jq ".[] | select(.id == $next_workspace) | .windows // 0")
    # echo "下个workspace 窗口数量:${next_window_count}:--下个workspace:::${next_workspace}"

    if [ -z "$next_window_count" ]; then
      # echo "wtz:::当前workspace没有window"
      hyprctl dispatch movetoworkspace "${next_workspace},address:${last_window}"
    else

      if [ "$next_window_count" -lt "$WINDOW_LIMIT" ]; then
        hyprctl dispatch movetoworkspace "${next_workspace},address:${last_window}"
      else
        # 大于3, 要判断下个workspace 是否满足条件，如果不满足继续下个workspace判断,直到找到条件
        next_workspace=$((next_workspace + 1))

        # 定义递归函数，返回符合条件的 workspace
        find_next_workspace() {
          local next_workspace1=$1 # 当前 workspace

          # echo "next_workspace1::${next_workspace1}"
          # 获取当前 workspace 的窗口数量
          local window_count=$(hyprctl workspaces -j | jq ".[] | select(.id == $next_workspace1) | .windows // 0")

          if [ -z "$window_count" ]; then
            window_count=0
          fi

          # 判断窗口数量是否小于指定的限制
          if [ "$window_count" -lt "$WINDOW_LIMIT" ]; then
            echo $next_workspace1 # 如果满足条件，返回当前的 workspace
            return 0
          else
            # 如果不满足条件，递归调用下一个 workspace
            next_workspace1=$((next_workspace1 + 1))
            find_next_workspace "$next_workspace1"
          fi
        }

        # 初始值：从 workspace 1 开始，查找窗口数量小于 2 的 workspace
        local next_index=$(find_next_workspace $next_workspace)
        hyprctl dispatch movetoworkspace "${next_index},address:${last_window}"

      fi

    fi

  fi

}

# 处理事件
handle() {
  local line="$1"

  # 根据事件类型调用不同的逻辑
  if echo "$line" | grep -q "openwindow"; then
    handle_new_window
  elif echo "$line" | grep -q "activewindow"; then
    echo "active" >>/tmp/move_window.log
  else
    echo "xx" >>/tmp/move_window.log
  fi
}

# 监听 Hyprland 的 socket
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
