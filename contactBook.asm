;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
compare_strings macro str1, str2
    push si
    push di 
    mov si, str1
    mov di, str2
compare_loop:
    cmpsb           
    jne done 
    cmp byte ptr [si-1], '$' 
    jne compare_loop
done:
    pop di
    pop si
compare_strings endm

;------------------------------------------------------------------------------

compare_strings2 macro str1, str2
    push si
    push di 
    mov si, str1
    mov di, str2
compare_loop2:
    cmpsb          
    jne done2      
    cmp byte ptr [si-1], '$'  
    jne compare_loop2
done2:
    pop di
    pop si
compare_strings endm 

;------------------------------------------------------------------------------

getchar macro
    mov ah,09
    lea dx, mssg
    int 21h
    mov ah, 1       
    int 21h
getchar endm
;------------------------------------------------------------------------------
fin macro msg
    lea dx, msg
    mov ah, 9
    int 21h
    mov ah, 1
    int 21h
    mov ax, 4c00h
    int 21h
ENDM
;------------------------------------------------------------------------------
printf MACRO msg
    lea dx, msg
    mov ah, 9
    int 21h
ENDM
;------------------------------------------------------------------------------
scanf macro input
    mov [input], 10
    mov ah, 0ah
    lea dx, input
    int 21h
    xor bh, bh
    mov bl, [input+1]
    mov byte ptr [input+2+bx], '$'
ENDM 
;------------------------------------------------------------------------------
copy macro copied, paste, length
    push si
    push di
    push ax
    mov cx, length
    mov si, 0
    mov di, 0
copy_loop:
    mov al, copied[si]
    mov paste[di], al
    inc si
    inc di
    loop copy_loop
    pop ax
    pop di
    pop si
ENDM
;------------------------------------------------------------------------------
addcontact MACRO
    LOCAL valid, unvalid
    mov al, book
    cmp al, 16d
    jl valid 
    printf fullbook
    jmp unvalid            
valid:        
    printf askname
    addname
    printf asknum
    addnum
    printf contactadded
    inc book 
unvalid: 
ENDM
;------------------------------------------------------------------------------
addname MACRO
    LOCAL for, name_done
    mov al, book
    xor ah, ah
    mov bx, 22d
    mul bx
    add ax, 1
    mov si, ax
    mov cx, 10
for:
    mov ah, 01
    int 21h
    cmp al, 0dh
    je name_done
    mov [book+si], al
    inc si
    dec cx
    jcxz name_done
    jmp for
name_done:
    mov byte ptr [book+si], '$'
ENDM
;------------------------------------------------------------------------------
addnum MACRO
    LOCAL for2, num_done
    mov al, book
    xor ah, ah
    mov bx, 22d
    mul bx
    add ax, 12
    mov si, ax
    mov cx, 10
for2:
    mov ah, 01
    int 21h
    cmp al, 0dh
    je num_done
    mov [book+si], al
    inc si
    dec cx
    jcxz num_done
    jmp for2
num_done:
    mov byte ptr [book+si], '$'
ENDM
;------------------------------------------------------------------------------
displayallcontact MACRO
    LOCAL valid_book, allcontact, done_display
    mov al, book
    cmp al, 0
    jg valid_book
    printf emptybook
    jmp done_display
valid_book:
    xor ch, ch
    mov cl, book
    mov bx, 1
allcontact:
    push cx
    printf namel
    push bx
    displayname
    pop bx
    printf numl
    displaynum
    add bx, 22
    pop cx
    loop allcontact
done_display:
ENDM
;------------------------------------------------------------------------------
displayname MACRO
    LOCAL display_name_loop, end_name_display
    mov si, bx
display_name_loop:
    mov dl, [book+si]
    cmp dl, '$'
    je end_name_display
    mov ah, 2
    int 21h
    inc si
    jmp display_name_loop
end_name_display:
ENDM
;------------------------------------------------------------------------------
displaynum MACRO
    LOCAL display_num_loop, end_num_display
    mov si, bx
    add si, 11
display_num_loop:
    mov dl, [book+si]
    cmp dl, '$'
    je end_num_display
    mov ah, 2
    int 21h
    inc si
    jmp display_num_loop
end_num_display:
ENDM

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

data segment
    search_buffer db 11 dup('$')
    contactfound db 0dh,0ah,"Contact found:",0dh,0ah,'$'
    contactnotfound db 0dh,0ah,"Contact not found.",0dh,0ah,'$'
    search_index db ?
    book db 0
         db '          $', '          $', '          $', '          $'
         db '          $', '          $', '          $', '          $'
         db '          $', '          $', '          $', '          $'
         db '          $', '          $', '          $', '          $'
         db '          $', '          $', '          $', '          $'
         db '          $', '          $', '          $', '          $'
         db '          $', '          $', '          $', '          $'
         db '          $', '          $', '          $', '          $'
    askname db 0dh,0ah,"Enter name: $"
    asknum db 0dh,0ah,"Enter number: $"
    contactadded db 0dh,0ah,"Contact added successfully$"
    fullbook db 0dh,0ah,"Book is full, failed to add contact$"
    emptybook db 0dh,0ah,"Book is empty$"
    namel db 0dh,0ah,"Name: $"
    numl db 0dh,0ah,"Number: $"
    pkey db 0dh,0ah,"Press any key...$"
    msg_delete db 0dh,0ah,"Delete contact - enter name to search:$"
    msg_deleted db 0dh,0ah,"Contact deleted successfully.$"
    msg_notfound db 0dh,0ah,"Contact does not exist.$"
    blank_contact db '          $'
    msg_modify db 0dh,0ah,"Enter name of contact to modify:$"
    msg_modified db 0dh,0ah,"Contact modified successfully.$"
    menu_title db 0dh,0ah,'   -Contact Book Menu- by Maram Daas ',0dh,0ah,'*************************************************************',0dh,0ah,'$'
    menu_option1 db '1. Add Contact',0dh,0ah,'$'
    menu_option2 db '2. Display All Contacts',0dh,0ah,'$'
    menu_option3 db '3. Search Contact by Name',0dh,0ah,'$'
    menu_option4 db '4. Delete Contact by Name (delete if theres more than one)',0dh,0ah,'$'
    menu_option5 db '5. Modify Contact by Name',0dh,0ah,'$'
    menu_option6 db '6. Exit',0dh,0ah,'$'
    menu_option7 db '7. display all contacts with a name starting with a prefix ',0dh,0ah,'$'
    menu_option8 db '8. display all contacts with a number starting with a prefix',0dh,0ah,'$'
    border db '*************************************************************',0dh,0ah,'$'
    menu_prompt db 0dh,0ah,'Enter your choice (1-8): $'
    menu_invalid db 0dh,0ah,'Invalid option! Please try again.',0dh,0ah,'$'
    msg_exiting db 0dh,0ah,'Exiting program... bye bye! <33',0dh,0ah,'$'
    mssg db 0dh,0ah,'press any key to return to main menu',0dh,0ah,'$'
    bfr db '$$$$$$'
ends

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

stack segment
    dw 128 dup(0)
ends 

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

code segment
start:
    mov ax, data
    mov ds, ax
    mov es, ax
    call menu
    fin pkey
ends

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

delete PROC
    push ax
    push bx
    push cx
    push si
    push di
    printf msg_delete
    call searchcontact
    cmp di, 0FFFFh
    je contact_not_found
    
    mov al, book
    cmp al, 1
    je delete_single_contact
    
    mov ax, di
    cmp ax, 22*15+1
    jae clear_single
    mov si, di
    add si, 22
    xor cx, cx
    mov cl, book
    dec cx
    mov ax, 22
    mul cx
    add ax, di
    mov cx, ax
    sub ax, di
shift_loop:
    mov bl, [book+si]
    mov [book+di], bl
    inc si
    inc di
    dec ax
    jnz shift_loop
    mov di, cx
    sub di, 22      
    jmp clear_contact
    
delete_single_contact:
    mov di, 1       
    jmp clear_contact
    
clear_single:
    mov di, ax
clear_contact:
    mov cx, 10
clear_name:
    mov byte ptr [book+di], ' '
    inc di
    loop clear_name
    mov byte ptr [book+di], '$'
    inc di          
    mov cx, 10
clear_num:
    mov byte ptr [book+di], ' ' 
    inc di
    loop clear_num
    mov byte ptr [book+di], '$'
    dec book
    printf msg_deleted
    jmp delete_done
contact_not_found:
    printf msg_notfound
delete_done:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
delete ENDP

;------------------------------------------------------------------------------
copy_block PROC
    push si
    push di
    push ax
    mov di, bx
copy_loop_proc:
    mov al, [si]
    mov [book+di], al
    inc si
    inc di
    loop copy_loop_proc
    pop ax
    pop di
    pop si
    ret
copy_block ENDP
;------------------------------------------------------------------------------
searchcontact PROC
    push ax
    push bx
    push cx
    push si
    printf askname
    mov cx, 10
    lea di, search_buffer
    mov al, '$'
    rep stosb
    lea si, search_buffer
    mov cx, 10
read_search_name_loop:
    mov ah, 01h
    int 21h
    cmp al, 0Dh
    je end_read_search
    mov [si], al
    inc si
    dec cx
    jnz read_search_name_loop
end_read_search:
    mov byte ptr [si], '$'
    xor ch, ch
    mov cl, book
    test cl, cl
    jz not_found
    mov di, 1
search_loop_proc:
    push cx
    push di
    mov si, di
    lea bx, search_buffer
compare_loop_proc:
    mov al, [book+si]
    cmp al, [bx]
    jne continue_search_proc
    cmp al, '$'
    je found_proc
    inc si
    inc bx
    jmp compare_loop_proc
continue_search_proc:
    pop di
    add di, 22
    pop cx
    loop search_loop_proc
not_found:
    printf contactnotfound
    mov di, 0FFFFh
    jmp done_search_proc
found_proc:
    pop di
    pop cx
    printf contactfound
    printf namel
    mov bx, di
    call displayname_proc
    printf numl
    mov bx, di
    call displaynum_proc
done_search_proc:
    pop si
    pop cx
    pop bx
    pop ax
    ret
searchcontact ENDP
;------------------------------------------------------------------------------
displayname_proc PROC
    push si
    push dx
    push ax
    mov si, bx
display_name_loop_proc:
    mov dl, [book+si]
    cmp dl, '$'
    je end_name_display_proc
    mov ah, 2
    int 21h
    inc si
    jmp display_name_loop_proc
end_name_display_proc:
    pop ax
    pop dx
    pop si
    ret
displayname_proc ENDP
;------------------------------------------------------------------------------
displaynum_proc PROC
    push si
    push dx
    push ax
    mov si, bx
    add si, 11
display_num_loop_proc:
    mov dl, [book+si]
    cmp dl, '$'
    je end_num_display_proc
    mov ah, 2
    int 21h
    inc si
    jmp display_num_loop_proc
end_num_display_proc:
    pop ax
    pop dx
    pop si
    ret
displaynum_proc ENDP
;------------------------------------------------------------------------------
modify PROC
    push ax
    push bx
    push cx
    push si
    push di
    printf msg_modify
    call searchcontact
    cmp di, 0FFFFh
    je modify_not_found
    printf asknum
    lea dx, search_buffer
    mov byte ptr [search_buffer], 10
    mov ah, 0Ah
    int 21h
    xor bh, bh
    mov bl, [search_buffer+1]
    mov byte ptr [search_buffer+2+bx], '$'
    add di, 11
    lea si, search_buffer+2
    mov cx, 10
modify_copy_loop:
    mov al, [si]
    cmp al, '$'
    je modify_pad_rest
    mov [book+di], al
    inc si
    inc di
    dec cx
    jnz modify_copy_loop
    jmp modify_terminate
modify_pad_rest:
    mov al, ' '
    rep stosb
modify_terminate:
    mov byte ptr [book+di], '$'
    printf msg_modified
    jmp modify_done
modify_not_found:
    printf msg_notfound
modify_done:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
modify ENDP
;------------------------------------------------------------------------------
menu PROC
    push ax
    push dx
menu_start:
    mov ax, 0600h
    mov bh, 07h
    xor cx, cx
    mov dx, 184Fh
    int 10h
    mov ah, 02h
    xor bh, bh
    xor dx, dx
    int 10h
    printf menu_title
    printf menu_option1
    printf menu_option2
    printf menu_option3
    printf menu_option4
    printf menu_option5
    printf menu_option6
    printf menu_option7
    printf menu_option8
    printf border
    printf menu_prompt
    mov ah, 01h
    int 21h
    cmp al, '1'
    je option_add
    cmp al, '2'
    je option_display
    cmp al, '3'
    je option_search
    cmp al, '4'
    je option_delete
    cmp al, '5'
    je option_modify
    cmp al, '6'
    je option_exit
    cmp al, '7'
    je option_display_contacts_by_prefix
    cmp al, '8'
    je option_display_contacts_by_prefix_number
    printf menu_invalid
    jmp menu_start
option_add:
    addcontact
    getchar
    jmp menu_start
option_display:
    displayallcontact
    getchar
    jmp menu_start
option_search:
    call searchcontact
    getchar
    jmp menu_start
option_delete:
    call delete
    getchar
    jmp menu_start
option_modify:
    call modify
    getchar
    jmp menu_start 
option_display_contacts_by_prefix:
    call displayprecontact
    getchar
    jmp menu_start
option_display_contacts_by_prefix_number:
    call displayprecontactnum
    getchar
    jmp menu_start    
option_exit:
    printf msg_exiting
    pop dx
    pop ax
    ret
menu ENDP

;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
displayprecontact proc
    push ax
    push bx
    push cx
    push si
    push di
    
    printf askname
    lea dx, search_buffer
    mov byte ptr [search_buffer], 10
    mov ah, 0Ah
    int 21h
    xor bh, bh
    mov bl, [search_buffer+1]
    mov byte ptr [search_buffer+2+bx], '$'
    
    mov al, book
    cmp al, 0
    jg valid_book
    printf emptybook
    jmp done_display
    
valid_book:
    xor ch, ch
    mov cl, book
    mov bx, 1      
    
allcontact:
    push cx
    push bx
    
    lea si, [book+bx]    
    lea di, [search_buffer+2]  
compare_loop:
    mov al, [di]
    cmp al, '$'
    je prefix_matches     
    cmp byte ptr [si], '$'
    je next_contact       
    cmpsb
    je compare_loop       
    jmp next_contact
    
prefix_matches:
    pop bx
    push bx
    printf namel
    displayname
    printf numl
    displaynum
    
next_contact:
    pop bx
    add bx, 22      
    pop cx
    loop allcontact
    
done_display:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
displayprecontact endp

;------------------------------------------------------------------------------
displayprecontactnum proc
    push ax
    push bx
    push cx
    push si
    push di
    
    printf asknum
    lea dx, search_buffer
    mov byte ptr [search_buffer], 10
    mov ah, 0Ah
    int 21h
    xor bh, bh
    mov bl, [search_buffer+1]
    mov byte ptr [search_buffer+2+bx], '$'
    
    mov al, book
    cmp al, 0
    jg valid_book2
    printf emptybook
    jmp done_display2
    
valid_book2:
    xor ch, ch
    mov cl, book
    mov bx, 1      
    
allcontact2:
    push cx
    push bx
    
    lea si, [book+bx+11]    
    lea di, [search_buffer+2]  
compare_loop2:
    mov al, [di]
    cmp al, '$'
    je prefix_matches2   
    cmp byte ptr [si], '$'
    je next_contact2       
    cmpsb
    je compare_loop2           
    jmp next_contact2
    
prefix_matches2:
    pop bx
    push bx
    printf namel
    displayname
    printf numl
    displaynum
    
next_contact2:
    pop bx
    add bx, 22     
    pop cx
    loop allcontact2
    
done_display2:
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
displayprecontactnum endp

;------------------------------------------------------------------------------

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
