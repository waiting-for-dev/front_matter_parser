def string
  "---
title: hello
---
Content"
end

def string_no_front_matter
  "Content"
end

def string_no_content
"---
title: hello
---
"
end

def string_comment(comment)
  "#{comment} ---
  #{comment} title: hello
  #{comment} ---
Content"
end

def string_start_comment(start_comment)
  "#{start_comment}
  ---
  title: hello
  ---
Content"
end

def string_start_end_comment(start_comment, end_comment)
  "#{start_comment}
---
title: hello
---
  #{end_comment}
Content"
end
