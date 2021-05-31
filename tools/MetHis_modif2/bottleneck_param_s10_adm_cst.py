#!/usr/bin/env python3

import argparse

# creates parser for command line arguments and parses them
def parse_args():
    parser = argparse.ArgumentParser(description='Modify parameters for bottleneck')
    parser.add_argument('-S10', '--s1.0',
                        type=str,
                        required=True,
                        help='Value of s1.0 (path to directory)',
                        dest='s10')
    parser.add_argument('-A', '--alpha',
                        type=str,
                        required=True,
                        help='Value of alpha (path to directory)',
                        dest='alpha')
    parser.add_argument('-U',
                        type=str,
                        required=True,
                        help='Value of U (path to directory)',
                        dest='nu')
    parser.add_argument('-ne0',
                        type=str,
                        required=True,
                        help='Value of ne0',
                        dest='ne0')
    parser.add_argument('-nef',
                        type=str,
                        required=True,
                        dest='nef',
                        help='Value of nef')
    parser.add_argument('-B', '--bottle',
                        type=str,
                        required=True,
                        dest='bottle',
                        help='Time of bottleneck')
    parser.add_argument('-G', '--max_gen',
                        type=int,
                        required=True,
                        dest='gen',
                        help='Number of generations')
    parser.add_argument('-S', '--max-simu',
                        type = int,
                        required = True,
                        dest = 'simu',
                        help = 'Number of simulations')
    parser.add_argument('-S1', '--contrib_s1',
                        type = float,
                        default = 0,
                        dest = 's1',
                        help = 'constant contribution of s1')
    parser.add_argument('-S2', '--contrib_s2',
                        type = float,
                        default = 0,
                        dest = 's2',
                        help = 'constant contribution of s2')

    values = parser.parse_args()
    return values.s10, values.alpha, values.nu, values.ne0, values.nef, values.bottle, values.gen, values.simu, values.s1, values.s2

#Read file with only increase population
def read_file(path_tot):
    with open(path_tot, "r") as filin:
        lines = filin.readlines()
    return lines

#Create bottleneck before/after actual lines
def write_file(lines, path_tot, ne0, nef, gen, s1, s2):
    with open(path_tot, "w") as filout:
        filout.write(lines[0])
        #New generation 0 with a larger population define by ne0
        old_line = lines[1].split()
        old_line_2 = lines[2].split()
        filout.write("0\t{}\t{}\t{}\n".format(ne0, old_line[2], old_line[3]))
        filout.write("1\t{}\t{}\t{}\n".format(old_line[1], 0, 0))

        for rg_l in range(2, len(lines)):
            line_tmp = lines[rg_l].split()
            filout.write("{}\t{}\t{}\t{}\n".format(rg_l, line_tmp[1], line_tmp[2], line_tmp[3]))

        #Completion after bottleneck until x generations (define by parameter gen)
        for rg_l in range(len(lines), gen+1):
            filout.write("{}\t{}\t{}\t{}\n".format(rg_l, nef, s1, s2))

#main function
def main():
    s10, alpha, nu, ne0, nef, bottle, gen, simu, s1, s2 = parse_args()
    for nb_simu in range(1,simu+1):
        path = "s1.0_0."+s10+"/alpha"+alpha+"/Nu"+nu+"/bottle"+bottle+"/Ne"+ne0+"-XXX/Ne"+ne0+"-"+nef+"/simu_"+str(nb_simu)+"/simu_"+str(nb_simu)+".par"
        pre_file = read_file(path)
        write_file(pre_file, path, ne0, nef, gen, s1, s2)

if __name__ == '__main__':
    main()
