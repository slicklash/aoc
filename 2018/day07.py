#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
from collections import defaultdict

from utils import copy_to_clipboard


def get_steps():
    with open('day07.txt', 'r') as f:
        return parse([x.rstrip() for x in f.readlines()])


def parse(lines):
    jobs = defaultdict(str)
    for line in lines:
        dep, step = re.findall(r'[A-Z]', line[1:])
        jobs[step] += dep
        if dep not in jobs:
            jobs[dep] = ''
    return jobs


@copy_to_clipboard
def part1(steps):
    done, jobs = '', dict(steps)

    def job_pool():
        while True:
            ready = (job for job, deps in jobs.items() if not deps and not job in done)
            yield next(iter(sorted(ready)))

    for job in job_pool():
        done += job
        for k in jobs:
            jobs[k] = jobs[k].replace(job, '')

    return done


@copy_to_clipboard
def part2(steps, worker_count=5, work_cost=60):
    jobs = dict(steps)
    total_seconds = -1
    workers = {}
    finish_time = {}
    done = []

    def job_pool():
        while True:
            ready = (
                job
                for job, deps in jobs.items()
                if not deps and not job in done and not job in workers.values()
            )
            yield next(iter(sorted(ready)), None)

    def worker_pool():
        while True:
            yield next(
                (i for i in range(worker_count) if not workers.get(i, None)), None
            )

    def work_on(worker, job):
        workers[worker] = job
        finish_time[job] = total_seconds + ord(job) - ord('A') + 1 + work_cost

    def process_jobs():
        for i in range(worker_count):
            job = workers.get(i, None)
            if job and finish_time[job] == total_seconds:
                done.append(job)
                workers[i] = ''
                for k in jobs:
                    jobs[k] = jobs[k].replace(job, '')

    while len(done) != len(jobs):
        total_seconds += 1
        process_jobs()
        for worker in worker_pool():
            if worker is None:
                break
            job = next(job_pool())
            if not job:
                break
            work_on(worker, job)

    return total_seconds


def main():
    jobs = parse(
        [
            'Step C must be finished before step A can begin.',
            'Step C must be finished before step F can begin.',
            'Step A must be finished before step B can begin.',
            'Step A must be finished before step D can begin.',
            'Step B must be finished before step E can begin.',
            'Step D must be finished before step E can begin.',
            'Step F must be finished before step E can begin.',
        ]
    )
    assert part1(jobs) == 'CABDFE'
    assert part2(jobs, 2, 0) == 15

    jobs = get_steps()
    assert part1(jobs) == 'MNQKRSFWGXPZJCOTVYEBLAHIUD'
    assert part2(jobs) == 948


if __name__ == '__main__':
    main()
