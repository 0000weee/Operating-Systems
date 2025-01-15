#include "kernel/types.h"
#include "user/user.h"
#include "user/list.h"
#include "user/threads.h"
#include "user/threads_sched.h"

#define NULL 0

/* default scheduling algorithm */
struct threads_sched_result schedule_default(struct threads_sched_args args)
{
    struct thread *thread_with_smallest_id = NULL;
    struct thread *th = NULL;
    list_for_each_entry(th, args.run_queue, thread_list) {
        if (thread_with_smallest_id == NULL || th->ID < thread_with_smallest_id->ID)
            thread_with_smallest_id = th;
    }

    struct threads_sched_result r;
    if (thread_with_smallest_id != NULL) {
        r.scheduled_thread_list_member = &thread_with_smallest_id->thread_list;
        r.allocated_time = thread_with_smallest_id->remaining_time;
    } else {
        r.scheduled_thread_list_member = args.run_queue;
        r.allocated_time = 1;
    }

    return r;
}

/* MP3 Part 1 - Non-Real-Time Scheduling */
/* Weighted-Round-Robin Scheduling */
struct threads_sched_result schedule_wrr(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the weighted round-robin scheduling algorithm
    
    struct thread* current_thread = list_entry(args.run_queue->next, struct thread, thread_list);
    if(current_thread->remaining_time >= current_thread->weight * args.time_quantum){
        r.allocated_time = current_thread->weight * args.time_quantum; 
        r.scheduled_thread_list_member = &list_entry(&current_thread->thread_list, struct thread, thread_list)->thread_list;
        //current_thread->remaining_time -= r.allocated_time;
    }
    else{
        r.allocated_time = current_thread->remaining_time; 
        r.scheduled_thread_list_member = &list_entry(&current_thread->thread_list, struct thread, thread_list)->thread_list;
        //current_thread->remaining_time = 0;
    }
    return r;
}

/* Shortest-Job-First Scheduling */
struct threads_sched_result schedule_sjf(struct threads_sched_args args)
{
    struct threads_sched_result r;
    // TODO: implement the shortest-job-first scheduling algorithm
    struct list_head* curr_node = args.run_queue->next;
    struct thread* shortest_thread = (list_entry(curr_node, struct thread, thread_list));
    r.scheduled_thread_list_member = &list_entry(curr_node, struct thread, thread_list)->thread_list;
    // case 1 :
    while(curr_node!=args.run_queue){
        struct thread* curr_thread = list_entry(curr_node, struct thread, thread_list);
        if(curr_thread->remaining_time < shortest_thread->remaining_time){
            shortest_thread = curr_thread;
            r.scheduled_thread_list_member = &(list_entry(curr_node, struct thread, thread_list)->thread_list);
        }
        else if(curr_thread->remaining_time == shortest_thread->remaining_time){
            if(curr_thread->ID < shortest_thread->ID){
                shortest_thread = curr_thread;
                r.scheduled_thread_list_member = &(list_entry(curr_node, struct thread, thread_list)->thread_list);
            }
            else{
                //
            }
        }
        curr_node = curr_node->next;
    }
    r.allocated_time = shortest_thread->remaining_time;
    
    // case 2 :
    curr_node = args.release_queue->next;//struct list_head* pointer
    while(curr_node!=args.release_queue){
        struct release_queue_entry* curr_release_node = list_entry(curr_node, struct release_queue_entry, thread_list);
        /*if(release_queue's release time < current_time + allocate time){
            if(release_node's remaining time < shortest_job's remining time)
                allocate time  = arrivial time - current time;
        }*/
        if(curr_release_node->release_time < args.current_time + r.allocated_time){
            if(curr_release_node->thrd->remaining_time < shortest_thread->remaining_time)
                r.allocated_time = curr_release_node->release_time - args.current_time;
        }
        curr_node = curr_node->next;
    }
    return r;
}

/* MP3 Part 2 - Real-Time Scheduling*/
/* Least-Slack-Time Scheduling */
struct threads_sched_result schedule_lst(struct threads_sched_args args)
{
    struct threads_sched_result r;
    r.allocated_time = 0;
    r.scheduled_thread_list_member = &list_entry(args.run_queue->next, struct thread, thread_list)->thread_list;
    // TODO: implement the least-slack-time scheduling algorithm

    // case 0: empty run queue
    
    if(list_empty(args.run_queue)){
        struct list_head* cur_release_node    = args.release_queue->next;
        struct list_head* min_release_node    = args.release_queue->next;
        while(cur_release_node!=args.release_queue){
            struct release_queue_entry* cur_release_entry = list_entry(cur_release_node, struct release_queue_entry, thread_list);
            struct release_queue_entry* min_release_entry = list_entry(min_release_node, struct release_queue_entry, thread_list);
            if(cur_release_entry->release_time < min_release_entry->release_time){
                min_release_node = cur_release_node;
                r.allocated_time = min_release_entry->release_time - args.current_time ;
            }
            else if(cur_release_entry->release_time == min_release_entry->release_time){
                if(cur_release_entry->thrd->ID <=  min_release_entry->thrd->ID){
                    min_release_node = cur_release_node;
                    r.allocated_time = min_release_entry->release_time - args.current_time ;
                }
            }
            cur_release_node = cur_release_node->next;
        }
        r.scheduled_thread_list_member = args.run_queue;
        //printf("sleep time: %d\n", r.allocated_time);
        return r;
    }
    // case 1: only consider run qieue
    
    struct list_head* curr_node = args.run_queue->next;
    struct thread*    shortest_thread = list_entry(curr_node, struct thread, thread_list);
    struct thread*    curr_thread     = list_entry(curr_node, struct thread, thread_list); 
    
    while(curr_node != args.run_queue){       
        int shortest_lst = shortest_thread->current_deadline - args.current_time - shortest_thread->remaining_time;
        int curr_lst     = curr_thread    ->current_deadline - args.current_time - curr_thread    ->remaining_time;
        
        if(curr_lst < shortest_lst){
            shortest_lst = curr_lst;
            shortest_thread = curr_thread;
            r.scheduled_thread_list_member = &list_entry(curr_node, struct thread, thread_list)->thread_list;
        }
        else if((curr_lst == shortest_lst)){
            if(curr_thread->ID <= shortest_thread->ID){
                shortest_lst = curr_lst;
                shortest_thread = curr_thread;
                r.scheduled_thread_list_member = &(list_entry(curr_node, struct thread, thread_list)->thread_list);
            }
            else{
                //
            }
        }
        curr_node = curr_node->next;
        curr_thread = list_entry(curr_node, struct thread, thread_list); 
    }
    r.allocated_time = shortest_thread->remaining_time;

    // case 2 : need consider release queue
    curr_node = args.release_queue->next;//struct list_head* pointer
    while(curr_node!=args.release_queue){
        struct release_queue_entry* curr_release_entry = list_entry(curr_node, struct release_queue_entry, thread_list);
        if(curr_release_entry->release_time < args.current_time + r.allocated_time){
            int release_lst = curr_release_entry->thrd->current_deadline - curr_release_entry->release_time - curr_release_entry->thrd->remaining_time;
            int shortest_lst = shortest_thread->current_deadline  - curr_release_entry->release_time - (shortest_thread->remaining_time -(curr_release_entry->release_time - args.current_time));
            if( release_lst < shortest_lst){
                r.allocated_time = curr_release_entry->release_time - args.current_time;
            }else if(release_lst == shortest_lst){
                if(curr_release_entry->thrd->ID <= shortest_thread->ID){
                    r.allocated_time = curr_release_entry->release_time - args.current_time;
                }
            }    
        }
        curr_node = curr_node->next;
    }

    if(r.allocated_time + args.current_time > shortest_thread->current_deadline){
        r.allocated_time = shortest_thread->current_deadline - args.current_time;
    }

    return r;
}

/* Deadline-Monotonic Scheduling */
struct threads_sched_result schedule_dm(struct threads_sched_args args)
{
    struct threads_sched_result r;
    r.allocated_time = 0;
    r.scheduled_thread_list_member = &list_entry(args.run_queue->next, struct thread, thread_list)->thread_list;
    //case 0: list is empty
    if(list_empty(args.run_queue)){
        //printf("queue is empty\n");
        struct list_head* cur_release_node    = args.release_queue->next;
        struct list_head* min_release_node    = args.release_queue->next;
        while(cur_release_node!=args.release_queue){
            struct release_queue_entry* cur_release_entry = list_entry(cur_release_node, struct release_queue_entry, thread_list);
            struct release_queue_entry* min_release_entry = list_entry(min_release_node, struct release_queue_entry, thread_list);
            if(cur_release_entry->release_time < min_release_entry->release_time){
                min_release_node = cur_release_node;
                r.allocated_time = min_release_entry->release_time - args.current_time ;
            }
            else if(cur_release_entry->release_time == min_release_entry->release_time){
                if(cur_release_entry->thrd->ID <=  min_release_entry->thrd->ID){
                    min_release_node = cur_release_node;
                    r.allocated_time = min_release_entry->release_time - args.current_time ;
                }
            }
            cur_release_node = cur_release_node->next;
        }
        r.scheduled_thread_list_member = args.run_queue;
        //printf("sleep time: %d\n", r.allocated_time);
        return r;
    }
    struct list_head* curr_node = args.run_queue->next;
    struct thread* shortest_thread = (list_entry(curr_node, struct thread, thread_list));

    // case 1 : only consider run queue's priority
    while(curr_node!=args.run_queue){
        struct thread* curr_thread = list_entry(curr_node, struct thread, thread_list);
        
        if(curr_thread->deadline < shortest_thread->deadline){
            shortest_thread = curr_thread;
        }
        else if(curr_thread->deadline == shortest_thread->deadline){
            if(curr_thread->ID < shortest_thread->ID){
                shortest_thread = curr_thread;
            }

        }
        curr_node = curr_node->next;
    }
    r.allocated_time = shortest_thread->remaining_time;
    r.scheduled_thread_list_member = &(shortest_thread->thread_list);
   // printf("allocated time before case 2: %d\n", r.allocated_time);
    //case 2 : over the deadline
    if(shortest_thread->current_deadline <= args.current_time){
      //  printf("current_deadline %d, current_time %d\n", shortest_thread->current_deadline,args.current_time);
        r.allocated_time = 0;
        r.scheduled_thread_list_member =  &(shortest_thread->thread_list);
        return r;
    }
    
    // case 3 : need consider release queue
    curr_node = args.release_queue->next;//struct list_head* pointer
    while(curr_node!=args.release_queue){
        struct release_queue_entry* curr_release_entry = list_entry(curr_node, struct release_queue_entry, thread_list);
        if(curr_release_entry->release_time < args.current_time + r.allocated_time){
            
            if( curr_release_entry->thrd->deadline < shortest_thread->deadline){
                r.allocated_time = curr_release_entry->release_time - args.current_time;
            }else if(curr_release_entry->thrd->deadline == shortest_thread->deadline){
                if(curr_release_entry->thrd->ID <= shortest_thread->ID){
                    r.allocated_time = curr_release_entry->release_time - args.current_time;
                }
            }    
        }
        curr_node = curr_node->next;
    }
    //printf("allocated time after case 3: %d\n", r.allocated_time);
    if(r.allocated_time + args.current_time > shortest_thread->current_deadline){
        r.allocated_time = shortest_thread->current_deadline - args.current_time;
    }

    return r;
}
