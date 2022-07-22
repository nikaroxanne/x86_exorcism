section .text
global find
find:
    ; Provide your implementation here
    ;;push rbp
;; find takes three parameters (rdi, rsi, rdx)
;; rdi = pointer to array of integers
;; rdi = *array
;; rsi = sizeof(array), as in, number of elements in array (not sizeof pointer to array)
;; rdx = key that we are searching for in the array


    mov rcx, rdi
    mov rdi, rsi
    mov r12, rdx 
    ;; check to see if the pointer to the array is NULL, meaning that the array is empty
    ;; in NASM, NULL is defined as zero
    cmp rdx, 0
    je binary_search_empty
    cmp rdi, 0
    je binary_search_empty
    push rdi
    push rsi
    push rdx
    call binary_search_non_empty 
    pop rdx
    pop rsi
    pop rdi
    ret

binary_search_empty:
    xor rax, rax
    dec rax
    ret

binary_search_non_empty:
  ;; index of key
  xor rax, rax
  
  ;; high
  ;;xor r9, r9
  ;; low
  xor rbx, rbx
  
  ;;set rcx to value of ARRAY_SIZE, which is on the stack at rsp+16
  ;;;;mov rcx, [rsp+16]
  ;; subtract 1 from rcx, so that rcx is at the index of last element in array
  ;;;;dec rdx
  
  ;;mid = (low + high) // 2
  ;;eax:edx / ecx
  ;; div ecx (result goes in ecx) 
  ;;
  mov rax, 0
  mov rdx, [rsp+16]
  mov rcx, 2
  div rcx
  mov r12, rcx

  xor r14, r14
  lea r14, [r12]
  imul r14, 8
  
  ;;if (low > high), then array is invalid, break out of this function, return -1
  cmp rdx, rbx
  jl binary_search_empty
  
  xor r13, r13
  ;;mov r13, [rsp+24+r14]
  mov r13, [rsp+24]
  cmp r13, [rsp+8]
  
  ;;add logic here for incrementing/decrementing high/low within loop
  ;;jne binary_search_non_empty
  mov rax, r13
  ret
  
    
